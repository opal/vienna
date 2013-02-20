module Vienna
  class View
    def self.element(selector=nil)
      selector ? @element = selector : @element
    end

    def self.events
      @events ||= []
    end

    def self.on(name, selector = nil, method = nil, &handler)
      handler = proc { |evt| __send__(method, evt) } if method
      events << [name, selector, handler]
    end

    def element
      return @element if @element

      if el = self.class.element
        el = Element.find el
      else
        el = Element.new tag_name
      end

      @element = el
    end

    # Method to override with code for rendering this element.
    #
    #     class MyView < Vienna::View
    #       def render
    #         element.html = "Welcome to this page!"
    #       end
    #     end
    #
    def render; end

    def class_name
      ''
    end

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

