local M = {}

---Return the most appropriate python interpreter for the current project.
function M.resolve_python()
  local lines = vim.fn.systemlist 'uv python find'
  if vim.v.shell_error == 0 and lines[1] and lines[1] ~= '' then
    local candidate = vim.trim(lines[1])
    if candidate ~= '' and vim.fn.filereadable(candidate) == 1 then
      vim.notify('[python-resolver] Using uv interpreter: ' .. candidate, vim.log.levels.INFO)
      return candidate
    end
  end

  for _, exe in ipairs { 'python3', 'python', 'py' } do
    local path = vim.fn.exepath(exe)
    if path and path ~= '' then
      return path
    end
  end

  vim.notify("[python-resolver] Falling back to plain 'python'", vim.log.levels.WARN)
  return 'python'
end

return M
