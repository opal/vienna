module Vienna
  module Columns
    def self.included(base)
      base.extend ClassMethods
    end

    module ClassMethods
      def add_column(attr_name)
        define_method(attr_name) { @attributes[attr_name] }
        define_method("#{attr_name}=") { |value| @attributes[attr_name] = value }
      end

      def boolean(attr_name)
        add_column attr_name
      end

      def date(attr_name)
        add_column attr_name
      end

      def float(attr_name)
        add_column attr_name
      end

      def integer(attr_name)
        add_column attr_name
        define_method("#{attr_name}=") { |value| @attributes[attr_name] = value.to_i }
      end

      def string(attr_name)
        add_column attr_name
      end

      def time(attr_name)
        add_column attr_name
      end
    end
  end
end
