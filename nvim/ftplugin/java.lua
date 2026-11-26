local jdtls = require("jdtls")

local home = os.getenv("HOME")
local jdtls_path = home .. "/.local/share/jdtls"
local lombok_jar = home .. "/.local/share/java/lombok.jar"
local launcher_jar = vim.fn.glob(jdtls_path .. "/plugins/org.eclipse.equinox.launcher_*.jar")

-- Direktori workspace unik per proyek
local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ":p:h:t")
local workspace_dir = vim.fn.stdpath("cache") .. "/jdtls/workspace/" .. project_name

-- Deteksi root directory proyek
local root_markers = { "pom.xml", "build.gradle", "build.gradle.kts", "mvnw", "gradlew", ".git" }
local root_dir = require("jdtls.setup").find_root(root_markers)
if root_dir == "" or root_dir == nil then
	root_dir = vim.fn.expand("%:p:h")
end

-- Capabilities untuk autocompletion (nvim-cmp / blink.cmp)
local capabilities = vim.lsp.protocol.make_client_capabilities()
local ok_cmp, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
if ok_cmp then
	capabilities = cmp_nvim_lsp.default_capabilities(capabilities)
end

local config = {
	cmd = {
		"/usr/lib/jvm/openjdk25/bin/java",
		"-Declipse.application=org.eclipse.jdt.ls.core.id1",
		"-Dosgi.bundles.defaultStartLevel=4",
		"-Declipse.product=org.eclipse.jdt.ls.core.product",
		"-Dlog.protocol=true",
		"-Dlog.level=ALL",
		"-Xmx1g",
		"--add-modules=ALL-SYSTEM",
		"--add-opens",
		"java.base/java.util=ALL-UNNAMED",
		"--add-opens",
		"java.base/java.lang=ALL-UNNAMED",
		"-javaagent:" .. lombok_jar,
		"-jar",
		launcher_jar,
		"-configuration",
		jdtls_path .. "/config_linux",
		"-data",
		workspace_dir,
	},

	root_dir = root_dir,
	capabilities = capabilities,

	settings = {
		java = {
			eclipse = {
				downloadSources = true,
			},
			configuration = {
				updateBuildConfiguration = "interactive",
				runtimes = {
					{
						name = "JavaSE-25",
						path = "/usr/lib/jvm/openjdk25",
						default = true,
					},
				},
			},
			maven = {
				downloadSources = true,
			},
			implementationsCodeLens = {
				enabled = true,
			},
			referencesCodeLens = {
				enabled = true,
			},
			references = {
				includeDecompiledSources = true,
			},
			signatureHelp = { enabled = true },
			contentProvider = { preferred = "fernflower" },
			completion = {
				favoriteStaticMembers = {
					"org.junit.Assert.*",
					"org.junit.jupiter.api.Assertions.*",
					"java.util.Objects.requireNonNull",
					"java.util.Objects.requireNonNullElse",
				},
			},
			sources = {
				organizeImports = {
					starThreshold = 9999,
					staticStarThreshold = 9999,
				},
			},
		},
	},

	init_options = {
		bundles = {},
	},
}

-- Keymap khusus refactoring Java
local opts = { silent = true, buffer = true }
vim.keymap.set("n", "<leader>jo", jdtls.organize_imports, opts)
vim.keymap.set("n", "<leader>jv", jdtls.extract_variable, opts)
vim.keymap.set("v", "<leader>jv", function()
	jdtls.extract_variable(true)
end, opts)
vim.keymap.set("n", "<leader>jc", jdtls.extract_constant, opts)
vim.keymap.set("v", "<leader>jm", function()
	jdtls.extract_method(true)
end, opts)

jdtls.start_or_attach(config)
