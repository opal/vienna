module Vienna
  # A RecordArray acts as a wrapper and delegator around an array of
  # record instances.
  #
  # NOTE: RecordArray implements many methods required so that it can
  # be run with method_missing turned off.
  class RecordArray < BasicObject
    attr_accessor :records

    def initialize
      @records = []
    end

    def method_missing(sym, *args, &block)
      @records.__send__(sym, *args, &block)
    end

    def each(&block)
      @records.each(&block)
    end

    def size
      @records.size
    end

    alias length size

    def push(obj)
      @records.push obj
    end
  end
end
