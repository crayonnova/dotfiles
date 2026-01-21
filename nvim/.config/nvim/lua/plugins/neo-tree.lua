return {
  "nvim-neo-tree/neo-tree.nvim",
  enabled = false,
  opts = {
    filesystem = {
      filtered_items = {
        hide_dotfiles = false, -- show files starting with .
        hide_gitignored = false, -- show files from .gitignore
      },
    },
  },
}
