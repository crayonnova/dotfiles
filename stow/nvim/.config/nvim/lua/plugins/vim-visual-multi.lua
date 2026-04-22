return {
  "mg979/vim-visual-multi",
  branch = "master",
  event = "VeryLazy",
  init = function()
    vim.g.VM_deafult_mappings = 0
    vim.g.VM_maps = {
      ["Find Under"] = "",
    }
    vim.g.VM_add_cursor_at_pos_no_mappings = 1
    vim.g.VM_use_nvim_namespace = 1
    vim.g.VM_exit_on_insert_mode = 0
    vim.g.VM_persistent_highlights = 0
  end,
}
