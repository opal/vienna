require 'vienna/model/attributes'

module Vienna

  # # Model
  #
  # Model is the base class to inherit from. Properties of the model
  # should be defined upfront which will create the necessary getter
  # and setter methods.
  #
  #   class MyModel < Vienna::Model
  #     property :name, :age
  #   end
  #
  #   user = MyModel.new
  #   user.name = 'Adam'
  #   user.age  = 42
  #
  # ## Property accessors
  #
  # Properties defined using `Model.property` will have the getter
  # and setter methods created for you. These methods simple set the
  # values on the internal `@attributes` ivar. `Model#[]` and
  # `Model#[]=` can also be used to set variables directly.
  #
  # If you require some special encoding/decoding behaviour from
  # incoming json or client side code, then you should override the
  # created getter/setter methods.
  #
  #   class User < Vienna::Model
  #     property :name
  #
  #     # ensure lowercase
  #     def name=(name)
  #       self[:name] = name.downcase
  #     end
  #
  #     # always report as lowercase
  #     def name
  #       self[:name].downcase
  #     end
  #   end
  #
  # The `[]` and `[]=` methods are used to set the real values which
  # will be serialized/deserialized into json for transport to the
  # server.
  module Model
    include Model::Attributes
    include Model::Fields
  end
end
