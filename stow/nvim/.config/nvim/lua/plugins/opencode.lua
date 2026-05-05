return {
  "nickjvandyke/opencode.nvim",
  version = "*", -- Latest stable release
  dependencies = {
    {
      -- `snacks.nvim` integration is recommended, but optional
      ---@module "snacks" <- Loads `snacks.nvim` types for configuration intellisense
      "folke/snacks.nvim",
      optional = true,
      opts = {
        input = {}, -- Enhances `ask()`
        picker = { -- Enhances `select()`
          actions = {
            opencode_send = function(...) return require("opencode").snacks_picker_send(...) end,
          },
          win = {
            input = {
              keys = {
                ["<a-a>"] = { "opencode_send", mode = { "n", "i" } },
              },
            },
          },
        },
      },
    },
  },
  config = function()
    local ok_snacks_terminal, snacks_terminal = pcall(require, "snacks.terminal")
    local ok_opencode_terminal, opencode_terminal = pcall(require, "opencode.terminal")

    if ok_snacks_terminal and ok_opencode_terminal then
      local opencode_cmd = "opencode --port"

      ---@type snacks.terminal.Opts
      local snacks_terminal_opts = {
        win = {
          position = "right",
          enter = false,
          on_win = function(win)
            opencode_terminal.setup(win.win)

            local buf = vim.api.nvim_win_get_buf(win.win)
            vim.keymap.set("n", "<C-h>", "<C-w>p", { buffer = buf, silent = true, desc = "Focus previous window" })
            vim.keymap.set("t", "<C-h>", [[<C-\><C-n><C-w>p]], {
              buffer = buf,
              silent = true,
              desc = "Focus previous window",
            })
          end,
        },
      }

      ---@type opencode.Opts
      vim.g.opencode_opts = {
        server = {
          start = function()
            snacks_terminal.open(opencode_cmd, snacks_terminal_opts)
          end,
          stop = function()
            local terminal = snacks_terminal.get(opencode_cmd, snacks_terminal_opts)
            if terminal then
              terminal:close()
            end
          end,
          toggle = function()
            snacks_terminal.toggle(opencode_cmd, snacks_terminal_opts)
          end,
        },
      }
    else
      ---@type opencode.Opts
      vim.g.opencode_opts = {
        -- Your configuration, if any; goto definition on the type or field for details
      }
    end

    vim.o.autoread = true -- Required for `opts.events.reload`

    vim.keymap.set({ "n", "x" }, "<leader>oa", function() require("opencode").ask("@this: ", { submit = true }) end, { desc = "Ask opencode…" })
    vim.keymap.set({ "n", "x" }, "<leader>ox", function() require("opencode").select() end,                             { desc = "Execute opencode action…" })
    vim.keymap.set({ "n", "t" }, "<leader>o.", function() require("opencode").toggle() end,                             { desc = "Toggle opencode" })

    vim.keymap.set({ "n", "x" }, "go",  function() return require("opencode").operator("@this ") end,        { desc = "Add range to opencode", expr = true })
    vim.keymap.set("n",          "goo", function() return require("opencode").operator("@this ") .. "_" end, { desc = "Add line to opencode", expr = true })

    vim.keymap.set("n", "<leader>ou", function() require("opencode").command("session.half.page.up") end,   { desc = "Scroll opencode up" })
    vim.keymap.set("n", "<leader>od", function() require("opencode").command("session.half.page.down") end, { desc = "Scroll opencode down" })
  end,
}
