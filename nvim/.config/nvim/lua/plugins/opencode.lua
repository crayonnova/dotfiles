return {
  "NickvanDyke/opencode.nvim",
  dependencies = {
    -- Recommended for `ask()` and `select()`.
    -- Required for `snacks` provider.
    ---@module 'snacks' <- Loads `snacks.nvim` types for configuration intellisense.
    {
      "folke/snacks.nvim",
    },
  },
  config = function()
    ---@type opencode.Opts
    vim.g.opencode_opts = {
      -- Your configuration, if any — see `lua/opencode/config.lua`, or "goto definition".
      -- provider = {
      --   enabled = "wezterm",
      --   wezterm = {
      --     -- Customize WezTerm options here if needed (see README for defaults)
      --     direction = "right",
      --   },
      -- },
      -- events = { reload = true },
    }

    -- Required for `opts.events.reload`.
    vim.o.autoread = true

    -- Function to focus the opencode window
    local function focus_opencode()
      for _, win in ipairs(vim.api.nvim_list_wins()) do
        local buf = vim.api.nvim_win_get_buf(win)
        if vim.bo[buf].filetype == "opencode_terminal" or vim.bo[buf].buftype == "terminal" then
          vim.api.nvim_set_current_win(win)
          return
        end
      end
      -- If not found, toggle to open it
      require("opencode").toggle()
    end

    -- Recommended/example keymaps.
    vim.keymap.set({ "n", "x" }, "<leader>op", function()
      require("opencode").ask("@this: ", { submit = true })
    end, { desc = "Opencode: Prompt" })
    vim.keymap.set({ "n", "x" }, "<leader>ox", function()
      require("opencode").select()
    end, { desc = "Opencode: Execute Action" })
    vim.keymap.set({ "n", "t" }, "<leader>ot", function()
      require("opencode").toggle()
    end, { desc = "Opencode: Toggle" })
    vim.keymap.set({ "n", "t" }, "<leader>of", focus_opencode, { desc = "Opencode: Focus" })

    vim.keymap.set({ "n", "x" }, "go", function()
      return require("opencode").operator("@this ")
    end, { expr = true, desc = "Opencode: Add range" })
    vim.keymap.set("n", "goo", function()
      return require("opencode").operator("@this ") .. "_"
    end, { expr = true, desc = "Opencode: Add line" })

    vim.keymap.set("n", "<leader>ou", function()
      require("opencode").command("session.half.page.up")
    end, { desc = "Opencode: Half Page Up" })
    vim.keymap.set("n", "<leader>od", function()
      require("opencode").command("session.half.page.down")
    end, { desc = "Opencode: Half Page Down" })
  end,
}
