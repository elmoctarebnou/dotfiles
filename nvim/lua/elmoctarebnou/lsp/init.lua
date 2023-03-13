local status_ok, _ = pcall(require, "lspconfig")
if not status_ok then
  return
end

require "elmoctarebnou.lsp.mason"
require("elmoctarebnou.lsp.handlers").setup()
require "elmoctarebnou.lsp.null-ls"
