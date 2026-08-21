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
        for _, group in ipairs({ "Normal", "NormalNC", "SignColumn", "EndOfBuffer", "FloatBorder", "NormalFloat" }) do
          highlights[group] = vim.tbl_extend("force", highlights[group] or {}, { bg = "NONE" })
        end
      end,
    },
  },
}
