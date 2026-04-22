vim.pack.add({ "https://gitlab.com/schrieveslaach/sonarlint.nvim.git" })

-- Patch: fix find_server_url crash when sonarcloud is an array (plugin bug)
local cm = require("sonarlint.connected_mode")
local _orig_notify = cm.notify_connection_result
cm.notify_connection_result = function(_, params, ctx)
  local client = vim.lsp.get_client_by_id(ctx.client_id)
  if not client then return end

  if params.success then
    vim.notify_once("Connected to SonarQube (" .. params.connectionId .. ")", vim.log.levels.DEBUG)
  end
  cm._connected_clients[client.id] = params.success and "connected" or "failed-connection"
end

local _orig_invalid = cm.notify_invalid_token
cm.notify_invalid_token = function(_, params, ctx)
  vim.notify("Invalid token for connection " .. params.connectionId, vim.log.levels.WARN)
end

if vim.fn.exepath("java") == "" then
  vim.notify("SonarLint requires Java", vim.log.levels.WARN)
  return
end

local mason_path = vim.fn.stdpath("data") .. "/mason"
local extension_path = mason_path .. "/packages/sonarlint-language-server/extension"
local analyzer_dir = mason_path .. "/share/sonarlint-analyzers"

local analyzer_names = {
  "sonarjs", "sonarpython", "sonarjava", "sonarjavasymbolicexecution",
  "sonarhtml", "sonarxml", "sonarphp", "sonargo", "sonarcsharp",
  "csharpenterprise", "sonarlintomnisharp", "sonartext", "sonariac",
}

local analyzers = {}
for _, name in ipairs(analyzer_names) do
  local path = analyzer_dir .. "/" .. name .. ".jar"
  if vim.fn.filereadable(path) == 1 then
    table.insert(analyzers, path)
  end
end

if #analyzers == 0 then
  vim.notify("SonarLint: no analyzers found. Run :Mason and install sonarlint-language-server", vim.log.levels.WARN)
  return
end

local cmd = { "sonarlint-language-server", "-stdio", "-analyzers" }
for _, analyzer in ipairs(analyzers) do
  table.insert(cmd, analyzer)
end

local connections = {
  sonarqube = {},
  sonarcloud = {},
}
local has_connected_mode = false
local missing = {}

if vim.env.SONARQUBE_URL then
  if not (vim.env.SONARQUBE_TOKEN or vim.env.SONAR_TOKEN) then
    table.insert(missing, "SONARQUBE_URL is set but SONAR_TOKEN/SONARQUBE_TOKEN is missing")
  else
    connections.sonarqube = { {
      connectionId = "sonarqube",
      serverUrl = vim.env.SONARQUBE_URL,
      disableNotifications = false,
    } }
    has_connected_mode = true
  end
end

if vim.env.SONARCLOUD_ORG then
  if not (vim.env.SONARQUBE_TOKEN or vim.env.SONAR_TOKEN) then
    table.insert(missing, "SONARCLOUD_ORG is set but SONAR_TOKEN/SONARQUBE_TOKEN is missing")
  else
    connections.sonarcloud = { {
      connectionId = "sonarcloud",
      region = "EU",
      organizationKey = vim.env.SONARCLOUD_ORG,
      disableNotifications = false,
    } }
    has_connected_mode = true
  end
end

if #missing > 0 then
  vim.notify("SonarLint: " .. table.concat(missing, "; "), vim.log.levels.WARN)
end

if not has_connected_mode then
  local reasons = {}
  if not vim.env.SONARQUBE_URL and not vim.env.SONARCLOUD_ORG then
    table.insert(reasons, "no SONARQUBE_URL or SONARCLOUD_ORG set")
  end
  vim.notify("SonarLint: standalone mode (" .. table.concat(reasons, ", ") .. ")", vim.log.levels.INFO)
end

require("sonarlint").setup({
  connected = has_connected_mode and {
    get_credentials = function()
      return vim.env.SONARQUBE_TOKEN or vim.env.SONAR_TOKEN
    end,
  } or nil,

  server = {
    cmd = cmd,

    init_options = {
      omnisharpDirectory = extension_path .. "/omnisharp",
      csharpOssPath = analyzer_dir .. "/sonarcsharp.jar",
      csharpEnterprisePath = analyzer_dir .. "/csharpenterprise.jar",
    },

    settings = {
      sonarlint = {
        connectedMode = has_connected_mode and { connections = connections } or nil,
      },
    },

    before_init = has_connected_mode and function(params, config)
      local config_path = params.rootPath .. "/.sonarlint.json"
      if vim.fn.filereadable(config_path) ~= 1 then
        vim.notify(
          "SonarLint: no .sonarlint.json in " .. params.rootPath .. " — no project binding, analysis will be limited",
          vim.log.levels.WARN
        )
        return
      end

      local ok, project = pcall(vim.fn.json_decode, vim.fn.readfile(config_path))
      if not ok then
        vim.notify("SonarLint: failed to parse .sonarlint.json", vim.log.levels.ERROR)
        return
      end
      if not project.projectKey then
        vim.notify("SonarLint: .sonarlint.json is missing 'projectKey'", vim.log.levels.ERROR)
        return
      end

      config.settings.sonarlint.connectedMode.project = {
        connectionId = project.connectionId or "sonarqube",
        projectKey = project.projectKey,
      }
    end or nil,
  },

  filetypes = {
    "javascript", "typescript", "typescriptreact", "javascriptreact",
    "python", "java", "html", "css", "json", "yaml", "xml", "php", "go", "cs",
  },
})
