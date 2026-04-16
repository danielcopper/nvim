return {
  cmd = { "azure-pipelines-language-server", "--stdio" },
  filetypes = { "yaml" },
  root_markers = { "Pipelines", "azure-pipelines.yml", ".azure-pipelines" },
  workspace_required = true,
  settings = {
    yaml = {
      schemas = {
        ["https://raw.githubusercontent.com/microsoft/azure-pipelines-vscode/master/service-schema.json"] = {
          "/azure-pipeline*.y*l",
          "/*.azure*",
          "Azure-Pipelines/**/*.y*l",
          "Pipelines/**/*.y*l",
          "pipelines/**/*.y*l",
        },
      },
    },
  },
}
