local set = vim.keymap.set

vim.api.nvim_create_autocmd("LspAttach", {
	group = vim.api.nvim_create_augroup("UserLspConfig", {}),
	callback = function(ev)
		local opts = { buffer = ev.buf }
		set("n", "gD", vim.lsp.buf.declaration, opts)
		set("n", "gd", vim.lsp.buf.definition, opts)
		set("n", "K", vim.lsp.buf.hover, opts)
		set("n", "gi", vim.lsp.buf.implementation, opts)
		set("n", "<space>rn", vim.lsp.buf.rename, opts)
		set({ "n", "v" }, "<space>ca", vim.lsp.buf.code_action, opts)
		set("n", "gr", vim.lsp.buf.references, opts)
		set("n", "<leader>d", vim.diagnostic.open_float, { desc = "Show diagnostic error messages" })
		set("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Open diagnostic list" })
		set("n", "[g", function()
			vim.diagnostic.jump({ count = -1, float = true })
		end, { desc = "Go to previous diagnostic" })
		vim.keymap.set("n", "]g", function()
			vim.diagnostic.jump({ count = 1, float = true })
		end, { desc = "Go to next diagnostic" })
	end,
})

set("n", "n", "nzzzv", { desc = "Next search result (centered)" })
set("n", "N", "Nzzzv", { desc = "Previous search result (centered)" })
set("n", "<C-d>", "<C-d>zz", { desc = "Half page down (centered)" })
set("n", "<C-u>", "<C-u>zz", { desc = "Half page up (centered)" })

set("x", "<leader>p", '"_dP', { desc = "Paste without yanking" })
set({ "n", "v" }, "<leader>x", '"_d', { desc = "Delete without yanking" })

set("n", "<leader>bn", ":bnext<CR>", { desc = "Next buffer" })
set("n", "<leader>bp", ":bprevious<CR>", { desc = "Previous buffer" })

set("n", "<leader>sv", ":vsplit<CR>", { desc = "Split window vertically" })
set("n", "<leader>sh", ":split<CR>", { desc = "Split window horizontally" })

set("v", "<M-k>", ":m '<-2<CR>gv=gv", { desc = "Move selection up" })
set("v", "<M-j>", ":m '>+1<CR>gv=gv", { desc = "Move selection down" })

set("v", "<", "<gv", { desc = "Indent left and reselect" })
set("v", ">", ">gv", { desc = "Indent right and reselect" })

set("n", "J", "mzJ`z", { desc = "Join lines and keep cursor position" })

set("n", "<Esc>", ":nohlsearch<CR>", { silent = true })

set("n", "<C-h>", "<C-w>h", { desc = "move left" })
set("n", "<C-j>", "<C-w>j", { desc = "move down" })
set("n", "<C-k>", "<C-w>k", { desc = "move up" })
set("n", "<C-l>", "<C-w>l", { desc = "move right" })
