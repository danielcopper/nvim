return {
  cmd = { "yaml-language-server", "--stdio" },
  filetypes = { "yaml", "yaml.docker-compose", "yaml.gitlab" },
  root_markers = { ".git" },
  settings = {
    yaml = {
      schemaStore = { enable = true },
      schemas = require("schemastore").yaml.schemas(),
    },
  },
}
