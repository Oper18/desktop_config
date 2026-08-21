-- ~/.config/nvim/lsp/ty.lua
return {
  cmd = { "ty", "server" },
  filetypes = { "python" },
  -- choose one or more root markers that match your projects
  root_markers = { "pyproject.toml", "setup.py", "setup.cfg", "requirements.txt", ".git" },
}
