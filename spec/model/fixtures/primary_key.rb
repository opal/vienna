require 'spec/spec_helper'

module ModelPrimaryKeySpecs
  class ModelA < Vienna::Model
    # use default primary_key
  end

  class ModelB < Vienna::Model
    primary_key :isbn
  end
end