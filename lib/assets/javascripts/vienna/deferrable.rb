module Vienna
  module Deferrable
    def callback(&block)
      @callback = block
    end
    
    def errback(&block)
      @errback = block
    end
    
    def succeed(*args)
      @callback.call *args if @callback
    end
    
    def fail(*args)
      @errback.call *args if @errback
    end
  end
end