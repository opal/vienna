module Vienna
  #     class UserView < Vienna::View
  #       def render
  #         @element.html = "<span>Name: #{content.name}, age: #{content.age}</span>"
  #       end
  #     end
  #
  #     user = User.new(name: 'Adam', age: 26)
  #     view = UserView.new(user)
  #
  #     view.element.html
  #     # => <span>Name: Adam, age: 26</span>
  class View
    def self.element(selector = nil)
      selector ? @selector = selector : @selector
    end

    attr_reader :element

    def initialize(*)
      if el = self.class.element
        @element = Document[el]
      else
        @element = JQuery.new
      end
      
      @binded_text_fields = []
    end
    
    def find(selector)
      @element.find(selector)
    end
    
    def render
      # 1. find template
      # 2. render it
      # 3. add all bindings
    end

    # @private Override TagHelper method
    def text_field_added(object, method, element_id)
      # @element.on(:change, "##{element_id}") do
        # object.set_attribute(method)
      # end

      # @binded_text_fields << [object, method, element_id]
    end
  end
end