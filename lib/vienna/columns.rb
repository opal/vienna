module Vienna
  module Columns
    def self.included(base)
      base.extend ClassMethods
    end

    module ClassMethods
      def add_column(attr_name, column_klass)
        columns[attr_name] = column_klass.new attr_name

        define_method(attr_name) { self[attr_name] }
        define_method("#{attr_name}=") { |value| self[attr_name] = value }
      end

      def boolean(attr_name)
        add_column attr_name, BooleanColumn
      end

      def date(attr_name)
        add_column attr_name, DateColumn
      end

      def float(attr_name)
        add_column attr_name, FloatColumn
      end

      def integer(attr_name)
        add_column attr_name, IntegerColumn
      end

      def string(attr_name)
        add_column attr_name, StringColumn
      end

      def time(attr_name)
        add_column attr_name, TimeColumn
      end

      def columns
        @columns ||= {}
      end
    end

    class Column
      def initialize(name, default = nil)
        @name = name
        @default = type_cast(default)
      end

      def type_cast(value)
        value
      end

      def type_cast_for_write(value)
        value
      end
    end

    class BooleanColumn < Column
      def type_cast(value)
        !!value
      end
    end

    class DateColumn < Column
    end

    class FloatColumn < Column
    end

    class IntegerColumn < Column
      def type_cast(value)
        value.to_i
      end
    end

    class StringColumn < Column
    end

    class TimeColumn < Column
    end
  end
end
