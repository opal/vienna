module Vienna
  class View
    def self.element(selector=nil)
      selector ? @element = selector : @element
    end

    def self.events
      @events ||= []
    end

    def self.on(name, selector, &handler)
      events << [name, selector, handler]
    end

    def initialize
      if el = self.class.element
        @element = Document[el]
      else
        @element = Element.new(tag_name)
      end

      self.class.events.each do |e|
        name, selector, handler = e
        @element.on(name, selector) { |e| instance_exec(e, &handler) }
      end
    end

    def tag_name
      :div
    end
  end
end