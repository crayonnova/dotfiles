return {
  {
    "kawre/leetcode.nvim",
    build = ":TSUpdate html", -- ensure html parser installed
    dependencies = {
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
      "folke/snacks.nvim",
    },
    opts = {
      lang = "javascript", -- set default language
      plugins = { non_standalone = false }, -- allow :Leet inside session
      picker = { provider = "snacks-picker" }, -- or "snacks-picker"
      hooks = {
        ["question_enter"] = {
          function()
            local function map(lhs, cmd, desc, modes)
              vim.keymap.set(modes or "n", lhs, function()
                vim.cmd(cmd)
              end, { buffer = true, silent = true, nowait = true, desc = desc })
            end
            -- Run on <leader>L (only in Leet buffers)
            map("<leader>S", "Leet submit", "Leet: Submit")
            -- Submit: pick a reliable chord (terminal can’t detect <S-CR>)
            map("<leader><CR>", "Leet run", "Leet: Run")
            --
            local buf = vim.api.nvim_get_current_buf()
            pcall(vim.keymap.del, "n", "<leader>c", { buffer = buf })
            map("<leader>c", "Leet console", "Leet: Console")
            -- Opencode integration
            map(
              "<leader>O",
              "lua require('opencode').ask('@leetcode problem: ', { submit = true })",
              "Ask opencode about problem"
            )
            map("<leader>T", "lua require('opencode').toggle()", "Toggle opencode chat")
            vim.keymap.set("x", "<leader>o", function()
              return require("opencode").operator("@leetcode code: ")
            end, { buffer = true, expr = true, desc = "Add selection to opencode" })
          end,
        },
      },
      storage = {
        home = vim.fn.stdpath("data") .. "/leetcode-solutions",
        cache = vim.fn.stdpath("cache") .. "/leetcode-solutions",
      },
      logging = true,
      description = { show_stats = true, width = "45%" },
      image_support = true,
    },
  },
}
