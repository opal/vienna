module Vienna
  module Attributes
    def [](name)
      @attributes[name]
    end

    def []=(name, value)
      column = @columns[name]

      if column
        @attributes[name] = value
      else
        # unknown attribute...
      end
    end

    def attributes=(attributes)
      attributes.each do |attr_name, value|
        @attributes[attr_name] = value
      end
    end

    def id
      self[@primary_key]
    end

    def id=(value)
      self[@primary_key] = value
    end
  end
end
