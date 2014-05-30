require 'template'
require 'vienna/output_buffer'
require 'active_support/core_ext/string'

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

    def self.template(name = nil)
      if name
        @template = name
      elsif @template
        @template
      elsif name = self.name
        @template = name.sub(/View$/, '').demodulize.underscore
      end
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
        scope.new tag_name
      end
    end

    def render_element
      before_render
      render
      after_render
    end

    def render
      if template = Template[self.class.template]
        @output_buffer = OutputBuffer.new
        element.html = instance_exec @output_buffer, template.body
      end
    end

    def before_render; end

    def after_render; end

    def class_name
      ""
    end

    def tag_name
      :div
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
