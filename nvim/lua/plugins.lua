vim.pack.add({
	{ src = "https://github.com/nvim-tree/nvim-web-devicons" },
	{ src = "https://github.com/stevearc/oil.nvim" },
	{ src = "https://github.com/nvim-lua/plenary.nvim", version = "master" },
	{ src = "https://github.com/ThePrimeagen/harpoon", version = "harpoon2" },
	{ src = "https://github.com/lewis6991/gitsigns.nvim" },
	{ src = "https://github.com/sindrets/diffview.nvim" },
	{ src = "https://github.com/m00qek/baleia.nvim" },
	{ src = "https://github.com/NeogitOrg/neogit" },
	{ src = "https://github.com/FabijanZulj/blame.nvim" },
	{ src = "https://github.com/windwp/nvim-autopairs" },
	{ src = "https://github.com/brenoprata10/nvim-highlight-colors" },
	{ src = "https://github.com/nvim-lualine/lualine.nvim" },
	{ src = "https://github.com/ibhagwan/fzf-lua" },
	{ src = "https://github.com/MeanderingProgrammer/render-markdown.nvim" },
	{ src = "https://github.com/rebelot/kanagawa.nvim" },
})

-- Colorscheme
require("kanagawa").setup({
	transparent = true,
	colors = {
		theme = {
			all = {
				ui = {
					bg_gutter = "none",
				},
			},
		},
	},
	overrides = function(colors)
		local theme = colors.theme
		return {
			NormalFloat = { bg = "none" },
			FloatBorder = { bg = "none" },
			FloatTitle = { bg = "none" },
			NormalDark = { fg = theme.ui.fg_dim, bg = "none" },
			Pmenu = { fg = theme.ui.shade0, bg = "none" },
			PmenuSel = { fg = "NONE", bg = theme.ui.bg_p1 },
			PmenuSbar = { bg = "none" },
			PmenuThumb = { bg = theme.ui.bg_p1 },
			BlinkCmpMenu = { bg = "none" },
			BlinkCmpMenuBorder = { fg = theme.ui.bg_p1, bg = "none" },
			BlinkCmpDoc = { bg = "none" },
			BlinkCmpDocBorder = { fg = theme.ui.bg_p1, bg = "none" },
		}
	end,
})
vim.cmd("colorscheme kanagawa")

-- Icons
require("nvim-web-devicons").setup({})

-- File Browser
require("oil").setup({
	win_options = {
		wrap = false,
		signcolumn = "no",
		cursorcolumn = false,
		foldcolumn = "0",
		spell = false,
		list = false,
		conceallevel = 3,
		concealcursor = "nvic",
	},
	view_options = {
		show_hidden = true,
	},
	float = {
		padding = 5,
		win_options = {
			winblend = 0,
		},
		border = "none",
		override = function(conf)
			local total_cols = vim.o.columns
			local total_lines = vim.o.lines
			local height = 20
			conf.relative = "editor"
			conf.row = total_lines - height - vim.o.cmdheight
			conf.col = 0
			conf.width = total_cols
			conf.height = height
			return conf
		end,
	},
})
vim.keymap.set("n", "<leader>e", function()
	require("oil").toggle_float()
end, { desc = "Open Oil floating window" })
vim.api.nvim_create_autocmd("FileType", {
	pattern = "oil",
	callback = function()
		vim.keymap.set("n", "q", require("oil").close, { buffer = true, desc = "Close Oil" })
	end,
})
vim.api.nvim_create_autocmd("FileType", {
	pattern = "oil",
	callback = function()
		vim.wo.winhl = "NormalFloat:Normal,FloatBorder:Normal"
	end,
})

-- Fuzzy Finder
local fzf = require("fzf-lua")
fzf.setup({
	{ "ivy", "borderless" },
})
vim.keymap.set("n", "<leader>ff", "<cmd>lua FzfLua.files()<CR>")
vim.keymap.set("n", "<leader>fb", "<cmd>lua FzfLua.buffers()<CR>")
vim.keymap.set("n", "<leader>fg", "<cmd>lua FzfLua.live_grep()<CR>")
vim.keymap.set("n", "<leader>fh", "<cmd>lua FzfLua.helptags()<CR>")
vim.keymap.set("n", "<leader>fc", function()
	require("fzf-lua").files({
		cwd = vim.fn.stdpath("config"),
	})
end, { desc = "Fzf Find Neovim Config Files" })

-- Mark File
local harpoon = require("harpoon")
harpoon:setup()
vim.keymap.set("n", "<leader>a", function()
	harpoon:list():add()
end)
vim.keymap.set("n", "<leader>fm", function()
	harpoon.ui:toggle_quick_menu(harpoon:list(), {
		title = "",
	})
end)
vim.keymap.set("n", "<leader>1", function()
	harpoon:list():select(1)
end)
vim.keymap.set("n", "<leader>2", function()
	harpoon:list():select(2)
end)
vim.keymap.set("n", "<leader>3", function()
	harpoon:list():select(3)
end)
vim.keymap.set("n", "<leader>4", function()
	harpoon:list():select(4)
end)
vim.api.nvim_create_autocmd("FileType", {
	pattern = "harpoon",
	callback = function()
		vim.wo.winhl = "NormalFloat:Normal,FloatBorder:Normal"
	end,
})

-- Git sign
require("gitsigns").setup({
	signcolumn = true,
	numhl = false,
	linehl = false,
	word_diff = false,
	watch_gitdir = {
		follow_files = true,
	},
	auto_attach = true,
	attach_to_untracked = false,
	current_line_blame = false,
	current_line_blame_opts = {
		virt_text = true,
		virt_text_pos = "eol",
		delay = 1000,
		ignore_whitespace = false,
		virt_text_priority = 100,
	},
	current_line_blame_formatter = "<author>, <author_time:%Y-%m-%d> - <summary>",
	sign_priority = 6,
	update_debounce = 100,
	status_formatter = nil,
	max_file_length = 40000,
	preview_config = {
		border = "single",
		style = "minimal",
		relative = "cursor",
		row = 0,
		col = 1,
	},
})

-- Git tools
require("blame").setup({})
vim.keymap.set("n", "<leader>gb", ":BlameToggle<CR>", {
	silent = true,
	desc = "Toggle Full Git Blame Window",
})

require("neogit").setup({
	kind = "split_below_all",
	commit_view = {
		kind = "split",
	},
})
vim.keymap.set("n", "<leader>gg", "<cmd>Neogit<cr>", { desc = "Open Neogit" })
vim.keymap.set("n", "<leader>gc", function()
	require("neogit").open({ "commit", kind = "split_below_all" })
end, { silent = true, desc = "Neogit View HEAD Commit" })
vim.keymap.set("n", "<leader>gh", "<cmd>NeogitCommit<cr>", { desc = "Open Neogit" })

-- Autopairs bracket
require("nvim-autopairs").setup()

-- Higlight colors pallete
require("nvim-highlight-colors").setup()

-- Statusline
local lualine = require("lualine")

local colors = {
	bg = "#000000",
	fg = "#dcd7ba",
	yellow = "#c0a36e",
	cyan = "#6a9589",
	darkblue = "#2d4f67",
	green = "#76946a",
	orange = "#FFA066",
	violet = "#957fb8",
	blue = "#7e9cd8",
	red = "#c34043",
}

local conditions = {
	buffer_not_empty = function()
		return vim.fn.empty(vim.fn.expand("%:t")) ~= 1
	end,
	hide_in_width = function()
		return vim.fn.winwidth(0) > 80
	end,
	check_git_workspace = function()
		local filepath = vim.fn.expand("%:p:h")
		local gitdir = vim.fn.finddir(".git", filepath .. ";")
		return gitdir and #gitdir > 0 and #gitdir < #filepath
	end,
}

local config = {
	options = {
		component_separators = "",
		section_separators = "",
		theme = {
			normal = { c = { fg = colors.fg, bg = colors.bg } },
			inactive = { c = { fg = colors.fg, bg = colors.bg } },
		},
	},
	sections = {
		lualine_a = {},
		lualine_b = {},
		lualine_y = {},
		lualine_z = {},
		lualine_c = {},
		lualine_x = {},
	},
	inactive_sections = {
		lualine_a = {},
		lualine_b = {},
		lualine_y = {},
		lualine_z = {},
		lualine_c = {},
		lualine_x = {},
	},
}

local function ins_left(component)
	table.insert(config.sections.lualine_c, component)
end

local function ins_right(component)
	table.insert(config.sections.lualine_x, component)
end

ins_left({
	function()
		local mode = vim.fn.mode()

		local mode_map = {
			n = "NORMAL",
			i = "INSERT",
			v = "VISUAL",
			V = "V-LINE",
			["\22"] = "V-BLOCK",
			c = "COMMAND",
			R = "REPLACE",
			t = "TERMINAL",
		}

		return mode_map[mode] or mode
	end,

	color = function()
		local mode_color = {
			n = colors.green,
			i = colors.yellow,
			v = colors.blue,
			V = colors.blue,
			["\22"] = colors.blue,
			c = colors.orange,
			R = colors.violet,
			t = colors.red,
		}

		return { fg = mode_color[vim.fn.mode()] }
	end,
})

ins_left({
	"branch",
	icon = "",
	color = { fg = colors.cyan, gui = "bold" },
})

ins_left({
	"diff",
	symbols = { added = " ", modified = "󰝤 ", removed = " " },
	diff_color = {
		added = { fg = colors.green },
		modified = { fg = colors.orange },
		removed = { fg = colors.red },
	},
	cond = conditions.hide_in_width,
})

ins_left({
	"filename",
	cond = conditions.buffer_not_empty,
	color = { fg = colors.fg, gui = "bold" },
})

ins_left({
	"diagnostics",
	sources = { "nvim_diagnostic" },
	symbols = { error = " ", warn = " ", info = " " },
	diagnostics_color = {
		error = { fg = colors.red },
		warn = { fg = colors.yellow },
		info = { fg = colors.cyan },
	},
})

ins_left({
	function()
		return "%="
	end,
})

local devicons = require("nvim-web-devicons")

ins_right({
	function()
		local client_name

		for _, client in ipairs(vim.lsp.get_clients({ bufnr = 0 })) do
			client_name = client.name
			break
		end

		if not client_name then
			return ""
		end

		local ft = vim.bo.filetype
		local icon = devicons.get_icon_by_filetype(ft, { default = true }) or ""

		return string.format("%s %s", icon, client_name)
	end,
	color = { fg = colors.blue, gui = "bold" },
})

ins_right({ "location", color = { fg = colors.green, gui = "bold" } })

ins_right({ "progress", color = { fg = colors.yellow, gui = "bold" } })

lualine.setup(config)

require("render-markdown").setup({
	latex = { enabled = false },
})
