return {
  {
    "folke/tokyonight.nvim",
    opts = {
      transparent = true,
      styles = {
        sidebars = "transparent",
        floats = "transparent",
      },
      on_highlights = function(highlights)
        highlights.Normal = { bg = "NONE" }
        highlights.NormalNC = { bg = "NONE" }
        highlights.SignColumn = { bg = "NONE" }
        highlights.EndOfBuffer = { bg = "NONE" }
        highlights.FloatBorder = { bg = "NONE" }
        highlights.NormalFloat = { bg = "NONE" }
      end,
    },
  },
}
