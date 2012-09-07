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

    # The content of a view is the object passed to the initializer.
    # This will in most cases be the model that the view is rendering
    # for.
    #
    # @return [Object]
    attr_reader :content

    attr_reader :element

    def initialize(content=nil)
      @content = content
    
      if el = self.class.element
        @element = Document[el]
      else
        @element = JQuery.new
      end
    end
    
    def find(selector)
      @element.find(selector)
    end
  end
end