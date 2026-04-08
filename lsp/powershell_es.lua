local bundle_path = vim.fn.stdpath("data") .. "/mason/packages/powershell-editor-services"

return {
  cmd = function(dispatchers)
    local temp_path = vim.fn.stdpath("cache")
    local command = string.format(
      [[& '%s/PowerShellEditorServices/Start-EditorServices.ps1' -BundledModulesPath '%s' -LogPath '%s/powershell_es.log' -SessionDetailsPath '%s/powershell_es.session.json' -FeatureFlags @() -AdditionalModules @() -HostName nvim -HostProfileId 0 -HostVersion 1.0.0 -Stdio -LogLevel Normal]],
      bundle_path, bundle_path, temp_path, temp_path
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
