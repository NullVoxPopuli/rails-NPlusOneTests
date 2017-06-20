# Be sure to restart your server when you modify this file.

# ApplicationController.renderer.defaults.merge!(
#   http_host: 'example.org',
#   https: false
# )
ActiveModel::Serializer.config.adapter = :json_api
# Not JSON API standard, but MUCH better for performance.
# Though, we could use this:
#   https://github.com/NullVoxPopuli/case_transform-rust-extensions
ActiveModelSerializers.config.key_transform = :unaltered

# Ember uses folder paths as namespaces, so separate with a slash.
ActiveModelSerializers.config.jsonapi_namespace_separator = '/'

# In order to properly handle JSON API responses,
# we need to register a JSON API renderer
ActiveSupport.on_load(:action_controller) do
  require 'active_model_serializers/register_jsonapi_renderer'
end
