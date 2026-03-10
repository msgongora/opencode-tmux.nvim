local M = {}

--- @return boolean
local function debug_enabled()
	local ok, state = pcall(require, "opencode-tmux.state")
	return ok and state.opts and state.opts.debug == true
end

---@return boolean
function M.in_tmux()
	return vim.fn.executable("tmux") == 1 and vim.env.TMUX ~= nil
end

---@param cmd string[]
---@return string
function M.run(cmd)
	local result = vim.system(cmd, { text = true }):wait()
	if result.code ~= 0 then
		return ""
	end
	return (result.stdout or ""):gsub("%s+$", "")
end

---@param cmd string[]
---@return string[]
function M.run_lines(cmd)
	local output = M.run(cmd)
	if output == "" then
		return {}
	end
	return vim.split(output, "\n", { plain = true, trimempty = true })
end

---@param message string
---@param level? integer
function M.notify(message, level)
	vim.notify("opencode-tmux: " .. message, level or vim.log.levels.INFO, { title = "opencode" })
end

---@param message string
function M.debug(message)
	if not debug_enabled() then
		return
	end
	M.notify(message, vim.log.levels.DEBUG)
end

return M
