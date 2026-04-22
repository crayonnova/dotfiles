return {
  "nvim-telescope/telescope.nvim",
  enabled = false,
  opts = {
    defaults = {
      file_ignore_patterns = {
        "node_modules",
        "%.git/",
        "dist/",
        "build/",
      },
    },
  },
}
