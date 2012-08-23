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

    def set_attribute(name, val)
      if respond_to? "#{name}="
        __send__ "#{name}=", val
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
    # The handler block gets passed two args; the new value of the
    # attribute, and the old value:
    #
    #   obj.observe(:first_name) do |new_value, old_value|
    #     puts "changed name from #{old_value} to #{new_value}"
    #   end
    #
    # @param [String, Symbol] name attribute name to start observing
    def observe(name, &handler)
      if name.include? '.'
        base = PathObserver.new name, handler
        base.object = self
      else
        observers = (@observers ||= {})

        unless handlers = observers[name]
          old_value = get_attribute(name)
          handlers  = observers[name] = []

          if respond_to? "#{name}="
            define_singleton_method("#{name}=") do |val|
              super val
              handlers.each { |h| h.call val, old_value }
              old_value = val
            end
          end
        end

        handlers << handler
      end

      handler
    end

    # Remove the handler for the given attribute `name`. If this object
    # does not have the handler as an observer for the given name then
    # nil is returned. (no error is raised).
    #
    #   object = Object.new
    #   proc   = proc { puts "changed!" }
    #
    #   object.observe(:foo, &proc)
    #   object.unobserve(:foo, proc)
    #
    # The handler should be passed in as a normal arg (not a block).
    #
    # @param [String, Symbol] name attribute name to remove observer for
    # @param [Proc] handler the proc to remove as handler
    def unobserve(name, handler)
      return unless @observers

      if handlers = @observers[name]
        handlers.delete handler
      end
    end

    # Used for observing a complex path.
    #
    # Setting up an observer such as:
    #
    #   base.observe('a.b.c') do
    #     puts "observer called"
    #   end
    #
    # Is the same as doing this manually:
    #
    #   o = PathObserver.new('a.b.c', proc { puts "observer called" })
    #   o.object = base
    #
    # The initialize method examines the path, and if it is complex
    # then it is split into the current attr to observe, and the
    # remaining path. The `@next` path observer is the result of
    # passing this remaining path to a new instance.
    #
    # If the path passed in to this instance is simple (i.e. a single
    # attr name), then no `next` observer is registered, and that
    # instance becomes the head of the chain as it is the one actually
    # observing our desired value. Only the head observer calls the
    # block passed into `new`.
    class PathObserver

      # @param [String, Symbol] path the attribute path for this part
      # observing
      def initialize(path, handler = nil)
        @handler = handler

        if path.include? '.'
          parts = path.partition '.'
          @attr = parts[0]
          @next = PathObserver.new(parts[2], handler)
        else
          @attr = path
        end
      end

      # The object that this observer is observing changes
      def object=(obj)
        return if obj == @object

        if @object = obj
          @object.observe(@attr) { value_changed }
        end

        value_changed
      end

      # The value of the attr `@name` on `@object` changed
      def value_changed
        value = @object.get_attribute @attr

        @next.object = value if @next
        @handler.call value if @handler
      end
    end

  end
end

class Object
  include Vienna::Observable
end