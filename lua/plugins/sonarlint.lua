-- SonarLint: Connected mode integration with SonarQube/SonarCloud for real-time code analysis
-- NOTE: Requires gitsigns.nvim for SCM integration (already in your config)

return {
  "https://gitlab.com/schrieveslaach/sonarlint.nvim",
  dependencies = {
    "neovim/nvim-lspconfig",
    "williamboman/mason.nvim",
  },
  -- Load after mason is ready
  event = "VeryLazy",

  config = function()
    -- Check for Java dependency (required to run SonarLint)
    local function check_java()
      local java_cmd = vim.fn.exepath("java")
      if java_cmd == "" then
        vim.notify(
          "SonarLint requires Java to run!\n" ..
          "Install Java with: sudo pacman -S jdk21-openjdk\n" ..
          "Or: sudo pacman -S jre21-openjdk (minimal)",
          vim.log.levels.ERROR,
          { title = "SonarLint - Missing Dependency" }
        )
        return false
      end
      return true
    end

    -- Check for gitsigns (recommended for SCM integration)
    local function check_gitsigns()
      local has_gitsigns = pcall(require, "gitsigns")
      if not has_gitsigns then
        vim.notify(
          "SonarLint works best with gitsigns.nvim for SCM integration",
          vim.log.levels.WARN,
          { title = "SonarLint - Recommended Plugin" }
        )
      end
      return has_gitsigns
    end

    -- Run dependency checks
    if not check_java() then
      return -- Don't continue setup if Java is missing
    end
    check_gitsigns()

    local mason_path = vim.fn.stdpath("data") .. "/mason"

    -- Ensure sonarlint-language-server is installed
    local registry = require("mason-registry")
    if registry.refresh then
      registry.refresh(function()
        local package_name = "sonarlint-language-server"
        if not registry.is_installed(package_name) then
          vim.notify("Installing " .. package_name .. "...", vim.log.levels.INFO)
          local ok, package = pcall(registry.get_package, package_name)
          if ok then
            package:install()
          end
        end
      end)
    end

    -- Build analyzer list from all installed analyzers
    local analyzers = {}
    local analyzer_dir = mason_path .. "/share/sonarlint-analyzers"

    -- List of all available analyzers (correct names)
    local analyzer_jars = {
      "sonarjs.jar",         -- JavaScript/TypeScript
      "sonarpython.jar",     -- Python
      "sonarjava.jar",       -- Java
      "sonarhtml.jar",       -- HTML
      "sonarxml.jar",        -- XML
      "sonarphp.jar",        -- PHP
      "sonargo.jar",         -- Go
      "sonarcsharp.jar",     -- C#
      "sonartext.jar",       -- Text/Secrets
      "sonariac.jar",        -- Infrastructure as Code
    }

    for _, jar in ipairs(analyzer_jars) do
      local analyzer_path = analyzer_dir .. "/" .. jar
      if vim.fn.filereadable(analyzer_path) == 1 then
        table.insert(analyzers, analyzer_path)
      end
    end

    -- Warn if no analyzers found
    if #analyzers == 0 then
      vim.notify(
        "No SonarLint analyzers found!\n" ..
        "Language server is installed but analyzers are missing.\n" ..
        "Try: :Mason and reinstall sonarlint-language-server",
        vim.log.levels.WARN,
        { title = "SonarLint - Missing Analyzers" }
      )
    end

    -- SonarLint configuration with connected mode
    -- Reads project-specific config from .sonarlint.json in project root
    require("sonarlint").setup({
      server = {
        -- Connected mode credentials (must be inside server block!)
        connected = vim.env.SONARQUBE_URL and {
          get_credentials = function(client_id, url)
            local token = vim.env.SONARQUBE_TOKEN or vim.fn.getenv("SONARQUBE_TOKEN")
            if not token or token == "" then
              vim.notify(
                string.format("SonarLint: get_credentials called for %s but token is nil!", url),
                vim.log.levels.ERROR,
                { title = "SonarLint Debug" }
              )
            end
            return token
          end,
        } or nil,
        cmd = {
          "sonarlint-language-server",
          "-stdio",
          "-analyzers",
          unpack(analyzers),
        },

        -- Required for C# analysis
        init_options = {
          omnisharpDirectory = mason_path .. "/packages/sonarlint-language-server/extension/omnisharp",
          csharpOssPath = mason_path .. "/share/sonarlint-analyzers/sonarcsharp.jar",
          csharpEnterprisePath = mason_path .. "/share/sonarlint-analyzers/csharpenterprise.jar",
        },

        settings = vim.env.SONARQUBE_URL and {
          sonarlint = {
            connectedMode = {
              connections = {
                sonarqube = {
                  {
                    connectionId = "lpa-sonarqube",
                    serverUrl = vim.env.SONARQUBE_URL,
                    disableNotifications = false,
                  },
                },
              },
            },
          },
        } or {},

        before_init = vim.env.SONARQUBE_URL and function(params, config)
          -- Read project config from .sonarlint.json in project root
          local sonarlint_config_path = params.rootPath .. "/.sonarlint.json"
          if vim.fn.filereadable(sonarlint_config_path) == 1 then
            local ok, project_config = pcall(vim.fn.json_decode, vim.fn.readfile(sonarlint_config_path))
            if ok and project_config.projectKey then
              config.settings.sonarlint.connectedMode.project = {
                connectionId = project_config.connectionId or "lpa-sonarqube",
                projectKey = project_config.projectKey,
              }
            end
          end
        end or nil,
      },

      filetypes = {
        "javascript",
        "typescript",
        "typescriptreact",
        "javascriptreact",
        "python",
        "java",
        "html",
        "css",
        "json",
        "yaml",
        "xml",
        "php",
        "go",
        "cs",
      },
    })

    -- Notify user about configuration status
    local status_msg = string.format("SonarLint configured with %d language analyzer(s)", #analyzers)

    if vim.env.SONARQUBE_URL and vim.env.SONARQUBE_TOKEN then
      vim.notify(
        status_msg .. "\nConnected mode enabled for: " .. vim.env.SONARQUBE_URL,
        vim.log.levels.INFO,
        { title = "SonarLint Ready" }
      )
    else
      vim.notify(
        status_msg .. "\nRunning in standalone mode.\n" ..
        "Set SONARQUBE_URL and SONARQUBE_TOKEN in .env for connected mode.",
        vim.log.levels.INFO,
        { title = "SonarLint Ready" }
      )
    end
  end,
}
