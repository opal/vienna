module Vienna::Model

  module Fields

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
      def field(name, options={})
        fields[name] = Field.new name, options

        define_method(name) { @attributes[name] }
        define_method("#{name}=") { |val| @attributes[name] = val }
      end

      def fields
        @fields ||= {}
      end
    end
  end
end
