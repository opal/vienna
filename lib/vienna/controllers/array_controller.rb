module Vienna
  class ArrayController
    include Enumerable

    attr_accessor :content

    def initialize(content=[])
      @content = content
    end

    def [](idx)
      @content[idx]
    end

    def []=(idx, value)
      @content[idx] = value
    end

    def each(&block)
      @content.each(&block)
    end
  end
end