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
      @element.setup_events

      @element
    end

    # The actual element for this view is created here. It is not assigned to
    # `@element`, it is simply returned. `#element` is responsible for setting
    # the `@element` variable.
    #
    # For custom subclasses, this is the place to override. The default
    # implementation will first check if an element was defined using the
    # `View.element` class method, and use that. Otherwise a new element is
    # created. This will be a 'div' element, but can be overriden using the
    # `#tag_name` method.
    #
    # ## Example: A subview that is created from a parent element
    # 
    #     class NavigationView < Vienna::View
    #       def initialize(parent, selector)
    #         @parent, @selector = parent, selector
    #       end
    #
    #       def create_element
    #         @parent.find(@selector)
    #       end
    #     end
    #
    # Assuming we have the html:
    #
    #     <div id="header">
    #       <img id="logo" src="logo.png" />
    #       <ul class="navigation">
    #         <li>Homepage</li>
    #       </ul>
    #     </div>
    #
    # We can use the navigation view like this:
    #
    #     @header = Element.find '#header'
    #     nav_view = NavigationView.new @header, '.navigation'
    #
    #     nav_view.element
    #     # => [<ul class="navigation">]
    # 
    # @return [Element] Should return the element for this view
    def create_element
      if el = self.class.element
        Element.find el
      else
        Element.new tag_name
      end
    end

    # Method to override with code for rendering this element.
    #
    #     class MyView < Vienna::View
    #       def render
    #         element.html = "Welcome to this page!"
    #       end
    #     end
    #
    # And then render:
    #
    #     view = MyView.new
    #     view.render
    #
    #     view.element
    #     # => <div>Welcome to this page!</div>
    #
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
        wrapper = proc { |e| instance_exec(c, &handler) }

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
  end

  def remove
    element.remove
  end

  def destroy
    teardown_events
    remove
  end
end

