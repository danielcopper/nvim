-- Java ftplugin - starts jdtls for Java files

local jdtls_path = vim.fn.stdpath("data") .. "/mason/packages/jdtls"
local launcher_jar = vim.fn.glob(jdtls_path .. "/plugins/org.eclipse.equinox.launcher_*.jar")

if launcher_jar == "" then
  vim.notify(
    "jdtls launcher not found at " .. jdtls_path .. " — run :Mason and install jdtls",
    vim.log.levels.ERROR
  )
  return
end

-- Find project root first
local root_markers = { "pom.xml", "build.gradle", "settings.gradle", ".git" }
local root_dir = require("jdtls.setup").find_root(root_markers)

-- Workspace per project (based on project root, not cwd)
local project_name = vim.fn.fnamemodify(root_dir or vim.fn.getcwd(), ":p:h:t")
local workspace_dir = vim.fn.stdpath("data") .. "/jdtls-workspace/" .. project_name

-- Detect OS for config folder
local config_dir = jdtls_path .. "/config_linux"
if vim.fn.has("mac") == 1 then
  config_dir = jdtls_path .. "/config_mac"
elseif vim.fn.has("win32") == 1 then
  config_dir = jdtls_path .. "/config_win"
end

local config = {
  cmd = {
    "java",
    "-Declipse.application=org.eclipse.jdt.ls.core.id1",
    "-Dosgi.bundles.defaultStartLevel=4",
    "-Declipse.product=org.eclipse.jdt.ls.core.product",
    "-Dlog.protocol=true",
    "-Dlog.level=ALL",
    "-Xmx1g",
    "--add-modules=ALL-SYSTEM",
    "--add-opens", "java.base/java.util=ALL-UNNAMED",
    "--add-opens", "java.base/java.lang=ALL-UNNAMED",
    "-jar", launcher_jar,
    "-configuration", config_dir,
    "-data", workspace_dir,
  },

  root_dir = root_dir,

  settings = {
    java = {
      inlayHints = {
        parameterNames = { enabled = "all" },
      },
      signatureHelp = { enabled = true },
      completion = {
        favoriteStaticMembers = {
          "org.junit.Assert.*",
          "org.junit.jupiter.api.Assertions.*",
        },
      },
    },
  },

  init_options = {
    bundles = {},
  },
}

require("jdtls").start_or_attach(config)
