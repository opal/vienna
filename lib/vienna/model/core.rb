module Vienna
  # Very core methods
  module Core
    module ClassMethods
      # Add a new instance of this model class from the given attributes.
      # The attributes should be a Hash (from json?).
      def add(attributes)
        arr = attributes.is_a?(Array) ? attributes : [attributes]

        arr.each do |hash|
          model = self.new hash
          model.instance_variable_set :@new_record, false

          id_map[model.id] = model
        end
      end

      # Return the model instance with the primary key of the given id.
      # This will return `nil` if no record exists locally.
      #
      # This will not try to load the record from the store if it does
      # not exist locally.
      #
      #     User.get(1)     # => #<User: (id: 1)>
      #     User.get(42)    # => nil
      #
      # @return [Object, nil]
      def get(id)
        id_map[id]
      end

      # Similar to `.get`, except that an error will be raised if the
      # model with the given id is not found.
      def get!(id)
        id_map[id] or raise "Not Found"
      end

      # Hash of all models from their id => instance
      def id_map
        @id_map ||= {}
      end
    end

    # @private
    def self.included(base); base.extend ClassMethods; end

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
      @fields      = self.class.fields

      @changed_attributes = {}
      @new_record         = true

      self.attributes = attrs
    end
  end
end