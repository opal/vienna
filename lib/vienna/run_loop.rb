module Vienna
  module RunLoop
    @queue = []

    def self.perform(&handler)
      @queue << handler
      self
    end

    def self.finish
      while handler = @queue.shift
        handler.call
      end

      self
    end
  end
end