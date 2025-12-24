vim.env.TABNINE_DOCKER_ENABLED = "1"

require('tabnine').setup({
  disable_auto_comment=true,
  accept_keymap="<Tab>",
  dismiss_keymap = "<C-]>",
  debounce_ms = 800,
  suggestion_color = {gui = "#808080", cterm = 244},
  codelens_color = { gui = "#808080", cterm = 244 },
  codelens_enabled = true,
  exclude_filetypes = {"TelescopePrompt", "NvimTree"},
  log_file_path = "/home/oper/.local/share/TabNine/TabNine.log",
  tabnine_enterprise_host = tabnine_enterprise_host,
  ignore_certificate_errors = false,
})
