module Vienna

  # Main attributes support for models
  module Attributes

    # Returns the current attributes set on this instance. It is
    # not good practice to access this hash directly, instead use the
    # created getter/setter methods for attributes.
    #
    # @return [Hash<Symbol, Object>]
    attr_reader :attributes

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

    def to_json
      @attributes.to_json
    end

    # @private extend ClassMethods into class as well
    def self.included(base)
      base.extend ClassMethods
    end

    module ClassMethods
      
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
      def attribute(name, type=:string)
        attributes[name] = BaseAttribute.new name, type

        define_method(name) { @attributes[name] }
        define_method("#{name}=") { |val| @attributes[name] = val }
      end

      def attributes
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
      def primary_key(key=nil)
        key ? @primary_key = key : @primary_key ||= :id
      end
    end
  end
end
