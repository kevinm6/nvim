-------------------------------------
-- File: jdtls.lua
-- Description:
-- Author: Kevin
-- Source: https://github.com/kevinm6/nvim/blob/nvim/lua/user/lsp/settings/jdtls.lua
-- Last Modified: 12/01/22 - 09:12
-------------------------------------

-- If you started neovim within `~/dev/xy/project-1` this would resolve to `project-1`
local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ':p:h:t')

local workspace_dir = '/Users/Kevin/.cache/workspace/' .. project_name

return {
  cmd = {
		'java',

    '-Declipse.application=org.eclipse.jdt.ls.core.id1',
    '-Dosgi.bundles.defaultStartLevel=4',
    '-Declipse.product=org.eclipse.jdt.ls.core.product',
    '-Dlog.protocol=true',
    '-Dlog.level=ALL',
    '-Xms1g',
    '--add-modules=ALL-SYSTEM',
    '--add-opens', 'java.base/java.util=ALL-UNNAMED',
    '--add-opens', 'java.base/java.lang=ALL-UNNAMED',

    '-jar', '/Users/Kevin/.local/share/nvim/lsp_servers/jdtls/plugins/org.eclipse.equinox.launcher_1.6.400.v20210924-0641.jar',

    '-configuration', '/Users/Kevin/.local/share/nvim/lsp_servers/jdtls/config_mac',

    '-data', workspace_dir
  },
	settings = {
		java = {
			codeGeneration = {
				generateComments = true
			},
		}
	}
}


