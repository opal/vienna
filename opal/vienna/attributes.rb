module Vienna
  module Attributes

    module ClassMethods
      def attributes(*attributes)
        attributes.each { |name| attribute name }
      end

      def attribute(attr_name)
        columns << attr_name

        define_method(attr_name) do
          @attributes[attr_name]
        end

        define_method("#{attr_name}=") do |val|
          @attributes[attr_name] = val
        end
      end

      def columns
        @columns ||= []
      end

      def primary_key(primary_key = nil)
        primary_key ? @primary_key = primary_key : @primary_key ||= :id
      end
    end

    def self.included(klass)
      klass.extend ClassMethods
    end

    def [](attribute)
      @attributes[attribute]
    end

    def []=(attribute, value)
      @attributes[attribute] = value
    end

    def attributes=(attributes)
      attributes.each do |name, value|
        setter = "#{name}="
        if respond_to? setter
          __send__ setter, value
        else
          instance_variable_set "@#{name}", value
        end
      end
    end
  end
end
