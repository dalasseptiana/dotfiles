vim.pack.add({
	{ src = "https://github.com/saghen/blink.lib" },
	{ src = "https://github.com/saghen/blink.cmp" },
	{ src = "https://github.com/neovim/nvim-lspconfig" },
	{ src = "https://github.com/stevearc/conform.nvim" },
	{ src = "https://github.com/nvim-treesitter/nvim-treesitter", version = "main" },
	{ src = "https://github.com/mfussenegger/nvim-jdtls", ft = "java" },
})

-- Autocompletion
local cmp = require("blink.cmp")
cmp.build():pwait()
cmp.setup({
	keymap = { preset = "default" },
	completion = { documentation = { auto_show = false } },
	sources = { default = { "lsp", "path", "snippets", "buffer" } },
	fuzzy = { implementation = "rust" },
})
local capabilities = cmp.get_lsp_capabilities()

-- Lsp Configuration
-- lua
vim.lsp.config("lua_ls", {
	cmd = { "lua-language-server" },
	filetypes = { "lua" },
	root_markers = { ".luarc.json", ".luarc.jsonc", ".git" },
	settings = {
		Lua = {
			runtime = { version = "LuaJIT" },
			diagnostics = { globals = { "vim", "hl" } },
			workspace = {
				checkThirdParty = false,
				library = { vim.env.VIMRUNTIME },
			},
		},
	},
	capabilities = capabilities,
})

-- C/C++
vim.lsp.config("clangd", {
	cmd = { "clangd" },
	filetypes = { "c", "cpp", "objc", "objcpp", "cuda", "proto" },
	root_markers = { ".git", "compile_commands.json", "compile_flags.txt" },
	capabilities = capabilities,
})

-- Rust
vim.lsp.config("rust_analyzer", {
	cmd = { "rust-analyzer" },
	filetypes = { "rust" },
	root_markers = { "Cargo.toml", ".git" },
	settings = {
		["rust-analyzer"] = {
			check = { command = "clippy" },
		},
	},
	capabilities = capabilities,
})

-- Golang
vim.lsp.config("gopls", {
	cmd = { "gopls" },
	filetypes = { "go", "gomod", "gowork", "gotmpl" },
	settings = {
		gopls = {
			analyses = {
				unusedparams = true,
			},
			staticcheck = true,
			gofumpt = true,
		},
	},
})

-- Zig
vim.lsp.config("zls", {
	cmd = { "zls" },
	filetypes = { "zig", "zir" },
	root_markers = { "build.zig", ".git" },
})

-- PHP
vim.lsp.config("intelephense", {
	cmd = { "intelephense", "--stdio" },
	filetypes = { "php" },
	root_markers = { "composer.json", ".git" },
})

-- JS & TS
vim.lsp.config("ts_ls", {
	cmd = { "typescript-language-server", "--stdio" },
	filetypes = {
		"javascript",
		"javascriptreact",
		"typescript",
		"typescriptreact",
	},
	root_markers = { "package.json", "tsconfig.json", "jsconfig.json", ".git" },
})

-- Python
vim.lsp.config("pyright", {
	cmd = { "pyright-langserver", "--stdio" },
	filetypes = { "python" },
	root_markers = { "pyproject.toml", "setup.py", "requirements.txt", ".git" },
})

vim.lsp.config("ruff", {
	cmd = { "ruff", "server" },
	filetypes = { "python" },
	root_markers = { "pyproject.toml", "ruff.toml", ".ruff.toml", ".git" },
})

-- HTML
vim.lsp.config("html", {
	cmd = { "vscode-html-language-server", "--stdio" },
	filetypes = { "html", "templ" },
	root_markers = { "package.json", ".git" },
})

-- CSS
vim.lsp.config("cssls", {
	cmd = { "vscode-css-language-server", "--stdio" },
	filetypes = { "css", "scss", "less" },
	root_markers = { "package.json", ".git" },
})

-- Enabling Lsp
vim.lsp.enable({
	"lua_ls",
	"clangd",
	"rust_analyzer",
	"gopls",
	"zls",
	"intelephense",
	"ts_ls",
	"pyright",
	"ruff",
	"html",
	"cssls",
})

-- Formatter
require("conform").setup({
	formatters_by_ft = {
		lua = { "stylua" },
		rust = { "rustfmt" },
		c = { "clang-format" },
		cpp = { "clang-format" },
		objc = { "clang-format" },
		go = { "goimports", "gofumpt" },
		zig = { "zigfmt" },
		php = { "pint" },
		javascript = { "prettier" },
		typescript = { "prettier" },
		javascriptreact = { "prettier" },
		typescriptreact = { "prettier" },
		python = { "ruff_organize_imports", "ruff_format" },
		html = { "prettier" },
		css = { "prettier" },
		scss = { "prettier" },
		java = { "google-java-format" },
	},
	format_on_save = { timeout_ms = 500, lsp_format = "fallback" },
})
vim.keymap.set({ "n", "v" }, "<leader>f", function()
	require("conform").format({ lsp_format = "fallback" })
end, { desc = "Format file" })

-- Parser
require("nvim-treesitter.config").setup({
	install_dir = vim.fn.stdpath("data") .. "/site",
	ensure_installed = {
		"c",
		"lua",
		"vim",
		"vimdoc",
		"query",
		"markdown",
		"markdown_inline",
		"rust",
		"go",
		"gomod",
		"gowork",
		"gosum",
		"markdown",
		"zig",
		"php",
		"phpdoc",
		"html",
		"javascript",
		"javascriptreact",
		"typescript",
		"typescriptreact",
		"tsx",
		"python",
		"css",
	},
	sync_install = false,
	auto_install = true,
	highlight = {
		enable = true,
		additional_vim_regex_highlighting = false,
	},
	indent = {
		enable = true,
	},
})
vim.api.nvim_create_autocmd("FileType", {
	pattern = "*",
	callback = function()
		pcall(vim.treesitter.start)
	end,
})
