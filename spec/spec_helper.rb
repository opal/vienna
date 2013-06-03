require 'vendor/jquery'
require 'opal-spec'
require 'opal-jquery'
require 'vienna'

class SimpleModel < Vienna::Model; end

class AdvancedModel < Vienna::Model
  primary_key :title
end
