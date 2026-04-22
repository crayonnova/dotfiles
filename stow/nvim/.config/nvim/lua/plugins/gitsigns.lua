return {
  "lewis6991/gitsigns.nvim",
  event = { "BufReadPre", "BufNewFile" },
  opts = {
    -- GitLens-style inline blame
    current_line_blame = true,
    current_line_blame_opts = {
      virt_text = true,
      virt_text_pos = "eol",
      delay = 400,
      ignore_whitespace = false,
    },

    current_line_blame_formatter = "<author>, <author_time:%Y-%m-%d> · <summary>",

    -- Performance / safety
    watch_gitdir = { follow_files = true },
    attach_to_untracked = false,
    update_debounce = 100,
    max_file_length = 40000,
    sign_priority = 6,
  },
}
