-- NixOS: los servidores LSP vienen de Nix (ya están en PATH), nunca de Mason.
--
-- Marcamos cada server con `mason = false` para que LazyVim llame a
-- `vim.lsp.enable()` y use el binario del PATH en lugar de instalarlo.
-- Añade aquí el nombre del server si activas un extra nuevo.
return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        lua_ls = { mason = false },
        clangd = { mason = false },
        neocmake = { mason = false },
        rust_analyzer = { mason = false },
        gopls = { mason = false },
        basedpyright = { mason = false },
        pyright = { mason = false },
        ruff = { mason = false },
        ruff_lsp = { mason = false },
        jdtls = { mason = false },
        omnisharp = { mason = false },
        fsautocomplete = { mason = false },
        jsonls = { mason = false },
        yamlls = { mason = false },
        taplo = { mason = false },
        nil_ls = { mason = false },
      },
    },
  },
  -- Mason sigue presente (dependencia de mason-lspconfig), pero no descarga
  -- nada: en NixOS los binarios precompilados no arrancan.
  {
    "mason-org/mason.nvim",
    opts = { ensure_installed = {} },
    config = function(_, opts)
      require("mason").setup(opts)
    end,
  },
}
