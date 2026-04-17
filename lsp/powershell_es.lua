local bundle_path = vim.fs.joinpath(vim.fn.stdpath("data"), "mason", "packages", "powershell-editor-services")

return {
  cmd = function(dispatchers)
    local temp_path = vim.fn.stdpath("cache")
    local script = vim.fs.joinpath(bundle_path, "PowerShellEditorServices", "Start-EditorServices.ps1")
    local log_path = vim.fs.joinpath(temp_path, "powershell_es.log")
    local session_path = vim.fs.joinpath(temp_path, "powershell_es.session.json")
    local command = string.format(
      [[& '%s' -BundledModulesPath '%s' -LogPath '%s' -SessionDetailsPath '%s' -FeatureFlags @() -AdditionalModules @() -HostName nvim -HostProfileId 0 -HostVersion 1.0.0 -Stdio -LogLevel Normal]],
      script, bundle_path, log_path, session_path
    )
    return vim.lsp.rpc.start({ "pwsh", "-NoLogo", "-NoProfile", "-Command", command }, dispatchers)
  end,
  filetypes = { "ps1" },
  root_markers = { "PSScriptAnalyzerSettings.psd1", ".git" },
  settings = {
    powershell = {
      codeFormatting = {
        preset = "OTBS",
        openBraceOnSameLine = true,
        newLineAfterOpenBrace = true,
        newLineAfterCloseBrace = true,
        whitespaceBeforeOpenBrace = true,
        whitespaceBeforeOpenParen = true,
        whitespaceAroundOperator = true,
        whitespaceAfterSeparator = true,
        ignoreOneLineBlock = true,
        alignPropertyValuePairs = true,
        useCorrectCasing = true,
      },
    },
  },
}
