local M = {}
local DEBUG_LOG_PATH = "/tmp/opencode-tmux-debug.log"

--- @return boolean
local function debug_enabled()
	local ok, state = pcall(require, "opencode-tmux.state")
	return ok and state.opts and state.opts.debug == true
end

---@param message string
local function append_debug_line(message)
	if not debug_enabled() then
		return
	end
	local line = os.date("%Y-%m-%d %H:%M:%S") .. " " .. message
	pcall(vim.fn.writefile, { line }, DEBUG_LOG_PATH, "a")
end

---@param name string
---@param args table|nil
local function debug_call(name, args)
	append_debug_line("call system." .. name .. " args=" .. vim.inspect(args or {}))
end

---@return boolean
function M.in_tmux()
	debug_call("in_tmux", nil)
	return vim.fn.executable("tmux") == 1 and vim.env.TMUX ~= nil
end

---@param cmd string[]
---@return string
function M.run(cmd)
	debug_call("run", { cmd = cmd })
	local result = vim.system(cmd, { text = true }):wait()
	if result.code ~= 0 then
		return ""
	end
	return (result.stdout or ""):gsub("%s+$", "")
end

---@param cmd string[]
---@return string[]
function M.run_lines(cmd)
	debug_call("run_lines", { cmd = cmd })
	local output = M.run(cmd)
	if output == "" then
		return {}
	end
	return vim.split(output, "\n", { plain = true, trimempty = true })
end

---@param message string
---@param level? integer
function M.notify(message, level)
	debug_call("notify", { message = message, level = level })
	vim.notify("opencode-tmux: " .. message, level or vim.log.levels.INFO, { title = "opencode" })
end

---@param message string
function M.debug(message)
	append_debug_line(message)
end

---@return string
function M.debug_log_path()
	return DEBUG_LOG_PATH
end

return M
