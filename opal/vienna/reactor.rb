module Vienna
  class Reactor
    def self.merge(*reactors)
      Merged.new(reactors)
    end

    def initialize(object, attr)
      @object = object
      @attribute = attr

      @observer = @object.add_observer(attr) do |val|
        resolve val
      end
    end

    def resolve(value)
      callbacks.each do |callback|
        callback.call value
      end
    end

    def callbacks
      @callbacks ||= []
    end

    def then(&block)
      callbacks << block
      self
    end

    def map(&block)
      Map.new(self, &block)
    end

    def select(&block)
      Select.new(self, &block)
    end

    def now
      @object.__send__ @attribute
    end

    class Map < Reactor
      def initialize(source, &block)
        @source = source
        @block = block

        source.then do |val|
          resolve block.call(val)
        end
      end

      def now
        @block.call @source.now
      end
    end

    class Select < Reactor
      def initialize(source, &block)
        @source = source
        @block = block

        source.then do |val|
          if block.call(val)
            resolve val
          end
        end
      end

      def now
        @block.call @source.now
      end
    end

    class Merged < Reactor
      def initialize(reactors)
        @reactors = reactors

        @reactors.each do |reactor|
          reactor.then { resolve @reactors.map(&:now) }
        end
      end
    end
  end
end
