reload('elmoctarebnou.options')
reload('elmoctarebnou.keymaps')

lvim.builtin.alpha.active = true
lvim.builtin.alpha.mode = "dashboard"
lvim.builtin.terminal.active = true
lvim.builtin.nvimtree.setup.view.side = "left"
lvim.builtin.nvimtree.setup.renderer.icons.show.git = false

-- Language parsers
lvim.builtin.treesitter.ensure_installed = {
    "bash",
    "c",
    "javascript",
    "json",
    "lua",
    "python",
    "typescript",
    "tsx",
    "css",
    "rust",
    "java",
    "yaml",
}

lvim.builtin.treesitter.ignore_install = { "haskell" }
lvim.builtin.treesitter.highlight.enable = true

lvim.builtin.cmp.mapping["<C-e>"] = function(fallback)
    local cmp = require "cmp"
    cmp.mapping.abort()
    local copilot_keys = vim.fn["copilot#Accept"]()
    if copilot_keys ~= "" then
        vim.api.nvim_feedkeys(copilot_keys, "i", true)
    else
        fallback()
    end
end

-- Additional Plugins
lvim.plugins = {
    { "lunarvim/colorschemes" },
    { "github/copilot.vim" },
    'chipsenkbeil/distant.nvim',
  config = function()
    require('distant').setup {
      -- Applies Chip's personal settings to every machine you connect to
      --
      -- 1. Ensures that distant servers terminate with no connections
      -- 2. Provides navigation bindings for remote directories
      -- 3. Provides keybinding to jump into a remote file's parent directory
      ['*'] = require('distant.settings').chip_default()
    }
  end
}
