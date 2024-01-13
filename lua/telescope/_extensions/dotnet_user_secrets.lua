return require("telescope").register_extension {
  setup = function(ext_config, config)
    -- access extension config and user config
  end,
  exports = {
    dotnet_user_secrets = require("dotnet_user_secrets").list_user_secrets
  },
}
