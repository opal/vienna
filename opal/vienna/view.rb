module Vienna
  class View
    def self.element(selector = nil)
      selector ? @element = selector : @element
    end

    def self.tag_name(tag = nil)
      define_method(:tag_name) { tag } if tag
    end

    def self.class_name(css_class = nil)
      define_method(:class_name) { css_class } if css_class
    end

    def self.events
      @events ||= []
    end

    def self.on(name, selector = nil, method = nil, &handler)
      handler = proc { |evt| __send__(method, evt) } if method
      events << [name, selector, handler]
    end

    attr_accessor :parent

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
        e = scope.new tag_name
        e.add_class class_name
      end
    end

    def render
    end

    def class_name
      ""
    end

    def tag_name
      "div"
    end

    def find(selector)
      element.find(selector)
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

