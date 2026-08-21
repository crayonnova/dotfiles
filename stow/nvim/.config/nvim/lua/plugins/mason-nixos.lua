return {
  {
    "mason-org/mason-lspconfig.nvim",
    opts = function(_, opts)
      opts.ensure_installed = {}
      opts.automatic_installation = false
      return opts
    end,
  },
  {
    "mason-org/mason.nvim",
    opts = function(_, opts)
      opts.ensure_installed = {}
      return opts
    end,
  },
  {
    "jay-babu/mason-nvim-dap.nvim",
    opts = function(_, opts)
      opts.ensure_installed = {}
      opts.automatic_installation = false
      return opts
    end,
  },
  {
    -- LazyVim auto-installs every configured server via Mason. On NixOS the
    -- pre-compiled lua-language-server binary won't run, so use the Nix one on
    -- PATH instead by opting lua_ls out of Mason management.
    "neovim/nvim-lspconfig",
    opts = function(_, opts)
      opts.servers = opts.servers or {}
      opts.servers.lua_ls = vim.tbl_deep_extend("force", opts.servers.lua_ls or {}, { mason = false })
      return opts
    end,
  },
}
