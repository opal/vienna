require 'vienna/observable_array'

module Vienna
  class RecordArray
    include ObservableArray

    attr_writer :content

    def ==(arr)
      if arr.respond_to? :content
        @content == arr.content
      else
        @content == arr
      end
    end

    def method_missing(sym, *args, &block)
      @content.__send__(sym, *args, &block)
    end

    def each(&block)
      @content.each(&block)
    end

    def size
      @content.size
    end

    alias length size
  end
end
