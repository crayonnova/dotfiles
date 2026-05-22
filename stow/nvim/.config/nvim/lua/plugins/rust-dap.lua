return {
  {
    "mrcjkb/rustaceanvim",
    opts = function(_, opts)
      local codelldb = vim.fn.exepath("codelldb")
      if codelldb ~= "" then
        opts.dap = {
          adapter = {
            type = "server",
            port = "${port}",
            host = "127.0.0.1",
            executable = {
              command = codelldb,
              args = { "--port", "${port}" },
            },
          },
        }
      end
      return opts
    end,
  },
  {
    "mfussenegger/nvim-dap",
    init = function()
      vim.api.nvim_create_autocmd("User", {
        pattern = "LazyDone",
        once = true,
        callback = function()
          local ok, dap = pcall(require, "dap")
          if not ok then return end
          local codelldb = vim.fn.exepath("codelldb")
          if codelldb ~= "" then
            dap.adapters.codelldb = {
              type = "server",
              port = "${port}",
              host = "127.0.0.1",
              executable = {
                command = codelldb,
                args = { "--port", "${port}" },
              },
            }
          end
        end,
      })
    end,
  },
}
