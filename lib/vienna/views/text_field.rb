require 'vienna/view'

module Vienna
  class TextField < View
    attr_accessor :value

    def render(renderer)
      renderer[:type]  = :text
      renderer[:value] = @value
    end

    def tag_name
      :input
    end
  end
end