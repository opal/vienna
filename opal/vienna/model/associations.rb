module Vienna
  module Associations
    module ClassMethods
      def associations
        @associations ||= []
      end

      def belongs_to(name)
        attr_accessor "#{name}_id"

        define_method(name) do
          instance_variable_get "@#{name}"
        end

        define_method("#{name}=") do |value|
          instance_variable_set "@#{name}", value
        end

        associations << { macro: :belongs_to }
      end

      def has_many(name)
        define_method(name) do
          instance_variable_get("@#{name}") ||
            instance_variable_set("@#{name}", [])
        end

        associations << { macro: :has_many }
      end
    end

    def self.included(base)
      base.extend ClassMethods
    end
  end
end
