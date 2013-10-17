module Vienna
  module Attributes
    module ClassMethods
      def attributes(*attributes)
        attributes.each { |name| attribute name }
      end

      def attribute(name)
        columns << name
        attr_accessor name
      end

      def columns
        @columns ||= []
      end

      def primary_key(primary_key = nil)
        primary_key ? @primary_key = primary_key : @primary_key ||= :id
      end
    end

    def self.included(klass)
      klass.extend(ClassMethods)
    end

    def [](attribute)
      instance_variable_get "@#{attribute}"
    end

    def []=(attribute, value)
      instance_variable_set "@#{attribute}", value
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

    def initialize(attributes = nil)
      @attributes = {}
      @new_record = true
      @loaded     = false

      self.attributes = attributes if attributes
    end
  end
end

