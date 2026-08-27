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
            opencode_send = function(picker) ---@param picker snacks.Picker
              local items = vim.tbl_map(function(item) ---@param item snacks.picker.Item
                return item.file
                    and require("opencode").format({ path = item.file, from = item.pos, to = item.end_pos })
                  or item.text
              end, picker:selected({ fallback = true }))

              require("opencode").prompt(table.concat(items, ", ") .. " ")
            end,
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

    local opencode_cmd = "opencode --port"

    ---@type snacks.terminal.Opts
    local snacks_terminal_opts = {
      win = {
        position = "right",
        enter = false,
        on_win = function(win)
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

    if ok_snacks_terminal then
      ---@type opencode.Opts
      vim.g.opencode_opts = {
        server = {
          start = function()
            snacks_terminal.open(opencode_cmd, snacks_terminal_opts)
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
    if ok_snacks_terminal then
      vim.keymap.set({ "n", "t" }, "<leader>o.", function() snacks_terminal.toggle(opencode_cmd, snacks_terminal_opts) end, { desc = "Toggle opencode" })
    end

    vim.keymap.set({ "n", "x" }, "go",  function() return require("opencode").operator("@this ") end,        { desc = "Add range to opencode", expr = true })
    vim.keymap.set("n",          "goo", function() return require("opencode").operator("@this ") .. "_" end, { desc = "Add line to opencode", expr = true })

    vim.keymap.set("n", "<leader>ou", function() require("opencode").command("session.half.page.up") end,   { desc = "Scroll opencode up" })
    vim.keymap.set("n", "<leader>od", function() require("opencode").command("session.half.page.down") end, { desc = "Scroll opencode down" })
  end,
}
