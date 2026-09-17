  return {
    {
      "mfussenegger/nvim-dap",
      optional = true,
      opts = function()
        local dap = require("dap")
        local js_debug = vim.fn.exepath("js-debug")
        if js_debug == "" then return end
        dap.adapters["pwa-node"] = {
          type = "server",
          host = "localhost",
          port = "${port}",
          executable = { command = js_debug, args = { "${port}" } },
        }
      end,
    },
  }
