local M = {}

-- Resolve the current working directory in a uv-friendly way, with fallbacks.
local function current_cwd()
	local uv = vim.uv or vim.loop
	if uv and uv.cwd then
		local ok, dir = pcall(uv.cwd)
		if ok and dir and dir ~= "" then
			return dir
		end
	end
	local ok, dir = pcall(vim.fn.getcwd)
	if ok and dir and dir ~= "" then
		return dir
	end
	return nil
end

-- Return the tail of the current project/root directory.
function M.root_name()
	local dir = current_cwd()
	if not dir or dir == "" then
		return ""
	end
	return vim.fn.fnamemodify(dir, ":t")
end

-- Produce a path relative to cwd (or home) for the buffer, normalizing separators on Windows.
function M.pretty_path(bufnr)
	bufnr = bufnr or 0
	local path = vim.api.nvim_buf_get_name(bufnr)
	if path == "" then
		return "[No Name]"
	end
	local formatted = vim.fn.fnamemodify(path, ":~:.")
	if formatted == "" then
		formatted = path
	end
	if vim.fn.has("win32") == 1 then
		formatted = formatted:gsub("\\", "/")
	end
	return formatted
end

-- Convenience lualine component showing the root name.
function M.lualine_root_component()
	return {
		function() return M.root_name() end,
		separator = "",
	}
end

-- Convenience lualine component showing the pretty buffer path.
function M.lualine_path_component()
	return {
		function() return M.pretty_path(0) end,
	}
end

return M
