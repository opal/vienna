module Vienna
  class BaseAttribute
    
    def self.inherited(base)
      if name = base.name
        name = name.sub(/Attribute$/, '').demodulize.underscore
        BaseAttribute[name] = base
      end
    end
    
    @subclasses = {}
    def self.[]=(name, klass)
      @subclasses[name] = klass
    end

    def self.[](name)
      @subclasses[name]
    end

    attr_reader :type

    def initialize(name, type=:string)
      @name = name
      @type = type
    end
  end
end
