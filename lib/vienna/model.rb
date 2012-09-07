require 'vienna/observable'

module Vienna
  # # Model
  #
  # Model is the base class to inherit from. Properties of the model
  # should be defined upfront which will create the necessary getter
  # and setter methods.
  #
  #   class MyModel < Vienna::Model
  #     attribute :name, :string
  #     attribute :age, :numeric
  #   end
  #
  #   user = MyModel.new
  #   user.name = 'Adam'
  #   user.age  = 42
  #
  # ## Property accessors
  #
  # Properties defined using `Model.attribute` will have the getter
  # and setter methods created for you. These methods simple set the
  # values on the internal `@attributes` ivar. `Model#[]` and
  # `Model#[]=` can also be used to set variables directly.
  #
  # If you require some special encoding/decoding behaviour from
  # incoming json or client side code, then you should override the
  # created getter/setter methods.
  #
  #   class User < Vienna::Model
  #     attribute :name
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
  class Model
    include Observable

    # Define a property on this model subclass. A model can only
    # serialize and work with properties that have been defined
    # this way.
    #
    #     class MyModel < Vienna::Model
    #       field :name
    #       field :age
    #     end
    #
    # @param [String, Symbol] name the property name
    def self.attribute(name, type=:string)
      attributes[name] = Attribute.new name, type
      
      define_method(name) { @attributes[name] }
      define_method("#{name}=") { |val| @attributes[name] = val }
    end
    
    def self.attributes
      @attributes ||= {}
    end
    
    # Used to either set or retrieve the primary key for instances of
    # this Model subclass.
    #
    # The primary key can be retreieved by:
    #
    #   ModelSubclass.primary_key
    #
    # It is best to set a custom key as early as possible inside the
    # class body definition:
    #
    #   class Book < Vienna::Model
    #     primary_key :isbn
    #
    #     property :title
    #     property :author
    #   end
    #
    # @param [Symbol] key optional key
    # @return [Symbol]
    def self.primary_key(key=nil)
      key ? @primary_key = key : @primary_key ||= :id
    end

    # Returns the current attributes set on this instance. It is
    # not good practice to access this hash directly, instead use the
    # created getter/setter methods for attributes.
    #
    # @return [Hash<Symbol, Object>]
    attr_reader :attributes

    # Create a new instance of this model. The initial attribute
    # values should be passed into this method. It is not a good idea
    # to override `initialize`, but if you do, make sure to call
    # `super`.
    #
    #   Movie.new title: 'My awesome movie'
    #
    # @param [Hash<Symbol, Object>] attrs initial attributes for model
    def initialize(attrs = {})
      @attributes  = {}
      @primary_key = self.class.primary_key
      @columns     = self.class.attributes

      @changed_attributes = {}
      @new_record         = true

      self.attributes = attrs
    end

    # Directly access the current underlying attribute value for the
    # given name. If the attribute has not been set, or has not been
    # defined using `Model.property`, then `nil` will be returned.
    #
    #   movie[:title]         # => "My awesome movie"
    #   movie.title = "omg"
    #   movie[:title]         # => "omg"
    #
    # @param [Symbol, String] name attribute name to lookup
    # @return [Object, nil] current attribute value or nil
    def [](name)
      column = @columns[name]
      @attributes[name]
    end

    # Directly set the underlying attribute value. This will skip the
    # created setter method.
    #
    #   movie = Movie.new title: "Awesome Movie 2"
    #   movie[:title] = "Even more awesome"
    #   movie.title   # => "Even more awesome"
    #
    # @param [Symbol] name attribute to set
    # @param [Object] value the value
    def []=(name, value)
      @attributes[name] = value
    end

    # Set some attributes on this model instance. This will not clear
    # any existing attributes, it will just set the ones in the given
    # hash.
    #
    #   user = User.new name: 'Ben', height: 196
    #   user.attributes = { name: 'Adam', age: 26 }
    #
    #   user.name     # => 'Adam'
    #   user.height   # => 196
    #
    # @param [Hash<Symbol, Object>] attrs hash of attributes to set
    def attributes=(attrs)
      attrs.each do |name, value|
        @attributes[name] = value
      end
    end

    def id
      self[@primary_key]
    end

    # Set this models id. This will set the attribute specified by the
    # primary key which defaults to `id`. Setting an id on a model will
    # mark the model as not new (if a model has an id, it must exist).
    #
    # @param [Object] id the id to set
    def id=(id)
      self[@primary_key] = id
    end
    
    # Returns whether or not this model is new. A model is new if it
    # has not yet been assigned an id. Models are assigned id's when
    # they are retrieved from the server (or saved and returned).
    #
    #   user = User.new name: 'adam'
    #   user.new_record?   # => true
    #
    #   user2 = User.new name: 'ben', id: 2
    #   user2.new_record?  # => false
    #
    # If the model has a custom primary key specified, then that
    # attribute will be used in the check instead of the default `id`.
    #
    # @return [true, false]
    def new_record?
      @new_record
    end

    def to_json
      @attributes.to_json
    end
  end
end