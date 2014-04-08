module Vienna
  module Observable

    def add_observer(attribute, &handler)
      unless observers = @attr_observers
        observers = @attr_observers = {}
      end

      if attribute.include? '.'
        return PathObserver.create(self, attribute, handler)
      end

      unless handlers = observers[attribute]
        handlers = observers[attribute] = []
        replace_writer_for(attribute)
      end

      handlers << handler
    end

    def remove_observer(attribute, handler)
      return unless @attr_observers

      if handlers = @attr_observers[attribute]
        handlers.delete handler
      end
    end

    # Triggers observers for the given attribute. You may call this directly if
    # needed, but it is generally called automatically for you inside a
    # replaced setter method.
    def attribute_did_change(attribute)
      return unless @attr_observers

      if handlers = @attr_observers[attribute]
        new_val = __send__(attribute) if respond_to?(attribute)
        handlers.each { |h| h.call new_val }
      end
    end

    # private?
    def replace_writer_for(attribute)
      if respond_to? "#{attribute}="
        define_singleton_method("#{attribute}=") do |val|
          result = super val
          attribute_did_change(attribute)
          result
        end
      end
    end
  end

  class PathObserver
    def self.create(object, path, handler)
      parts = path.split '.'
      base = PathObserver.new parts[0]
      last = base

      parts.drop(1).each do |attr|
        last = last.next = PathObserver.new(attr)
      end

      base.object = object
      last.handler = handler
    end

    attr_accessor :next, :handler

    def initialize(attr)
      @attr = attr
    end

    def object=(obj)
      return if obj == @object

      if @object = obj
        obj.add_observer(@attr) { value_changed }
      end

      value_changed
    end

    def value_changed
      value = @object.__send__ @attr

      @next.object = value if @next
      @handler.call value if @handler
    end
  end
end
