module Vienna
  module Observable

    # Gets the attribute by the given name. This currently will only
    # retrieve simple properties, by trying for a method with the given
    # name first, then trying with a "?" prefix for boolean attributes.
    # If neither are methods on this object, then nil is returned.
    #
    # @param [String, Symbol] name attribute name to get
    # @return [Object, nil]
    def get_attribute(name)
      if respond_to? name
        __send__ name
      elsif respond_to? "#{name}?"
        __send__ "#{name}?"
      end
    end

    # Start observing an attribute on this object. This will replace the
    # setter method for the given attribute with a singleton one on this
    # instance that calls super, to use the default implementation, and
    # will then loop over all registered observers, passing the new value
    # to the each block.
    #
    #   class Foo
    #     attr_accessor :name
    #   end
    #
    #   obj = Foo.new
    #   obj.observe(:name) { |val| "name is #{val}" }
    #
    #   obj.name = 'adam'
    #   obj.name = 'tom'
    #
    #   # => name is "adam"
    #   # => "name is tom"
    #
    # @param [String, Symbol] name attribute name to start observing
    def observe(name, &handler)
      observers = (@__observers ||= {})

      unless handlers = observers[name]
        handlers = observers[name] = []
        define_singleton_method("#{name}=") do |val|
          super val
          handlers.each { |h| h.call val }
        end
      end

      handlers << handler
    end

  end
end

class Object
  include Vienna::Observable
end