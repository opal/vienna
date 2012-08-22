module Vienna
  class Field

    attr_reader :type

    def initialize(name, options={})
      @name = name
      @options = options
      @type = options[:type] || String
    end
  end
end
