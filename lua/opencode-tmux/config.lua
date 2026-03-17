local M = {}
local DEBUG_LOG_PATH = "/tmp/opencode-tmux-debug.log"

---@param message string
local function append_debug_line(message)
	local line = os.date("%Y-%m-%d %H:%M:%S") .. " " .. message
	pcall(vim.fn.writefile, { line }, DEBUG_LOG_PATH, "a")
end

---@param name string
---@param args table|nil
local function debug_call(name, args)
	local merged = vim.tbl_deep_extend("force", vim.deepcopy(M.defaults or {}), args or {})
	if merged.debug == true then
		append_debug_line("call config." .. name .. " args=" .. vim.inspect(args or {}))
	end
end

---@class opencode_tmux.Opts
---@field enabled? boolean
---@field cmd? string
---@field options? string
---@field focus? boolean
---@field allow_passthrough? boolean
---@field auto_close? boolean
---@field find_sibling? boolean
---@field debug? boolean
---@field connect_keymap? string|false
---@field connect_launch? boolean

---@type opencode_tmux.Opts
M.defaults = {
	enabled = true,
	cmd = "opencode --port",
	options = "-h",
	focus = false,
	allow_passthrough = false,
	auto_close = false,
	find_sibling = true,
	debug = false,
	connect_keymap = false,
	connect_launch = false,
}

---@type opencode_tmux.Opts
M.options = vim.deepcopy(M.defaults)

---@param opts? opencode_tmux.Opts
---@return opencode_tmux.Opts
function M.setup(opts)
	debug_call("setup", opts)
	M.options = vim.tbl_deep_extend("force", vim.deepcopy(M.defaults), opts or {})
	return M.options
end

return M
