module Vienna
  module Observable

    def add_observer(attribute, &handler)
      unless observers = @attr_observers
        observers = @attr_observers = {}
        old_values = @attr_old_values = {}
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
end
