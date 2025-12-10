local M = {}

local LOG = vim.log.levels
local DEFAULT_SNACKS_TERM_COUNT = 1

-- Send a namespaced notification to the user.
local function notify(message, level)
  vim.notify('[pytest] ' .. message, level or LOG.INFO)
end

-- Decide which pytest runner command should be used.
local function resolve_runner()
  local configured = vim.g.pytest_runner
  if type(configured) == 'table' and #configured > 0 then
    return vim.deepcopy(configured)
  end
  if vim.fn.executable('uv') == 1 then
    return { 'uv', 'run', 'pytest' }
  end
  return { 'pytest' }
end

-- Build the shell command string for a given pytest target.
local function make_command(target, extra_args)
  local parts = resolve_runner()
  if type(extra_args) == 'table' then
    for _, arg in ipairs(extra_args) do
      table.insert(parts, arg)
    end
  end
  if target and target ~= '' then
    table.insert(parts, target)
  end
  return table.concat(parts, ' ')
end

-- Return file path relative to the workspace (or absolute fallback).
local function relative_file(bufnr)
  local name = vim.api.nvim_buf_get_name(bufnr)
  if name == '' then
    return nil
  end
  local rel = vim.fn.fnamemodify(name, ':.')
  if rel == '' then
    rel = vim.fn.fnamemodify(name, ':p')
  end
  rel = rel:gsub('\\\\', '/')
  return rel
end

-- Collect enclosing class/function names via Tree-sitter to build node ids.
local function scope_components(bufnr)
  if vim.bo[bufnr].filetype ~= 'python' then
    return nil, 'Not a python buffer'
  end
  local ok, parser = pcall(vim.treesitter.get_parser, bufnr, 'python')
  if not ok then
    return nil, 'Tree-sitter parser for python is unavailable'
  end
  local tree = parser:parse()[1]
  if not tree then
    return nil, 'Unable to parse python buffer'
  end
  local row, col = unpack(vim.api.nvim_win_get_cursor(0))
  row = row - 1
  local node = tree:root():named_descendant_for_range(row, col, row, col)
  if not node then
    return nil, 'Place the cursor inside a test'
  end
  local scopes = {}
  while node do
    local t = node:type()
    if t == 'function_definition' or t == 'async_function_definition' or t == 'class_definition' then
      local name_node = node:field('name')[1]
      if name_node then
        table.insert(scopes, 1, vim.treesitter.get_node_text(name_node, bufnr))
      end
    end
    node = node:parent()
  end
  if #scopes == 0 then
    return nil, 'Cursor is not inside a class or function'
  end
  return scopes
end

-- Reuse or spawn a Snacks terminal dedicated to pytest runs.
local function ensure_terminal(opts)
  local ok, Snacks = pcall(require, 'snacks')
  if not ok or not Snacks.terminal then
    return nil, nil, 'Snacks.terminal is unavailable'
  end

  local focus = opts and opts.focus or false
  local count = vim.g.pytest_snacks_terminal_count or DEFAULT_SNACKS_TERM_COUNT
  local terminal_opts = {
    count = count,
    interactive = true,
    auto_close = false,
    start_insert = true,
    auto_insert = true,
    win = {
      enter = focus,
    },
  }

  local ok_get, terminal, _ = pcall(Snacks.terminal.get, nil, terminal_opts)
  if not ok_get or not terminal then
    local err = ok_get and 'Unable to create Snacks terminal' or terminal
    return nil, nil, type(err) == 'string' and err or 'Failed to open Snacks terminal'
  end

  terminal:show()
  if focus then
    terminal:focus()
  end

  local buf = terminal.buf
  if not buf or not vim.api.nvim_buf_is_valid(buf) then
    return nil, nil, 'Invalid Snacks terminal buffer'
  end

  local chan = vim.b[buf] and vim.b[buf].terminal_job_id
  if not chan then
    return nil, nil, 'Snacks terminal job is missing'
  end

  vim.b[buf].pytest_terminal = true
  return buf, chan
end

-- Send a pytest command line to the managed terminal buffer.
local function send_to_terminal(cmd, opts)
  local buf, chan, err = ensure_terminal(opts)
  if not chan then
    notify(err or 'Unable to start pytest terminal', LOG.ERROR)
    return false
  end
  vim.fn.chansend(chan, cmd .. "\r")
  notify('Running: ' .. cmd)
  return true
end

-- Build a fully-qualified pytest node id (file::Class::method) for the cursor.
function M.current_node_id(bufnr)
  bufnr = bufnr or vim.api.nvim_get_current_buf()
  local file = relative_file(bufnr)
  if not file then
    return nil, 'Buffer has no file name'
  end
  local scopes, err = scope_components(bufnr)
  if not scopes then
    return nil, err
  end
  return file .. '::' .. table.concat(scopes, '::')
end

-- Resolve the current buffer's file path to use as a pytest target.
function M.file_target(bufnr)
  bufnr = bufnr or vim.api.nvim_get_current_buf()
  local file = relative_file(bufnr)
  if not file then
    return nil, 'Buffer has no file name'
  end
  return file
end

-- Run pytest for an arbitrary target, caching the command for re-use.
function M.run(target, opts)
  local cmd = make_command(target, opts and opts.extra_args or nil)
  if send_to_terminal(cmd, opts) then
    M._last_command = cmd
  end
end

-- Run the test nearest to the cursor.
function M.run_nearest()
  local node_id, err = M.current_node_id()
  if not node_id then
    notify(err, LOG.WARN)
    return
  end
  M.run(node_id)
end

-- Run all tests in the current file.
function M.run_file()
  local file, err = M.file_target()
  if not file then
    notify(err, LOG.WARN)
    return
  end
  M.run(file)
end

-- Re-run the most recent pytest command.
function M.run_last()
  if not M._last_command then
    notify('No pytest command has been executed yet', LOG.WARN)
    return
  end
  send_to_terminal(M._last_command)
end

return M
