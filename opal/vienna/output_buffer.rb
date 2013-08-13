require 'template'

module Vienna
  class OutputBuffer < Template::OutputBuffer
    def capture(*args, &block)
      old = @buffer
      tmp = @buffer = []
      yield(*args) if block_given?
      @buffer = old
      tmp.join
    end
  end
end
