reload('elmoctarebnou.options')
reload('elmoctarebnou.keymaps')
reload('elmoctarebnou.toggleterm')

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

lvim.plugins = {
    { "lunarvim/colorschemes" },
    { "github/copilot.vim" },
    'chipsenkbeil/distant.nvim',
    'christoomey/vim-tmux-navigator',
  config = function()
    require('distant').setup {
      ['*'] = require('distant.settings').chip_default()
    }
  end
}
