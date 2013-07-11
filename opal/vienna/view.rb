module Vienna
  class View
    def self.element(selector = nil)
      selector ? @element = selector : @element
    end

    def self.events
      @events ||= []
    end

    def self.on(name, selector = nil, method = nil, &handler)
      handler = proc { |evt| __send__(method, evt) } if method
      events << [name, selector, handler]
    end

    attr_accessor :parent

    # Returns the element for this view. This is created lazily on the first
    # time the method is called. It is not recommended to override this
    # method. Instead, override `#create_element` to simply return the element
    # representing this view.
    #
    # Once the element is created, registered events will also be added to the
    # created element. Also, any classes listed in the `#class_name` method will
    # be added to the created element. Class names are added to any existing
    # class names, so classes on an existing element will not be replaced.
    #
    # @return [Element] the element representing this view
    def element
      return @element if @element

      @element = create_element
      @element.add_class class_name
      setup_events

      @element
    end

    def create_element
      scope = (self.parent ? parent.element : Element)

      if el = self.class.element
        scope.find el
      else
        scope.new tag_name
      end
    end

    def render; end

    # The class name that should be set on the element, once created.
    #
    # @return [String] class name to set on the element
    def class_name
      ""
    end

    # When the element is created, the tag name can be overriden using this
    # method. It defaults to a div element.
    #
    # @return [Symbol] tag name for the element
    def tag_name
      :div
    end

    def setup_events
      return @dom_events if @dom_events

      el = element
      @dom_events = self.class.events.map do |event|
        name, selector, handler = event
        wrapper = proc { |e| instance_exec(e, &handler) }

        el.on(name, selector, &wrapper)
        [name, selector, wrapper]
      end
    end

    def teardown_events
      el = element
      @dom_events.each do |event|
        name, selector, wrapper = event
        el.off(name, selector, &wrapper)
      end
    end

    def remove
      element.remove
    end

    def destroy
      teardown_events
      remove
    end
  end
end

