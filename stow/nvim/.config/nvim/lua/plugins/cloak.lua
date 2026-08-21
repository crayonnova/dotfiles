return {
  "laytan/cloak.nvim",
  event = "BufReadPre",
  opts = {
    enabled = true,
    cloak_character = "*",
    highlight_group = "Comment",
    patterns = {
      {
        file_pattern = { ".env", ".env.*", "*.env", "secrets.*", "*.secret" },
        cloak_pattern = "=.+",
        replace = nil,
      },
    },
  },
  keys = {
    { "<leader>ct", "<cmd>CloakToggle<cr>", desc = "Toggle Cloak" },
  },
}
