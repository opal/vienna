require 'vienna/observable'

module Vienna
  module ObservableArray
    include Vienna::Observable

    attr_reader :content

    def initialize(content = [])
      @content = content
    end

    def inspect
      "#<ObservableArray: #{content.inspect}>"
    end

    alias to_s inspect

    def array_content_did_change(idx, removed, added)
      if observers = @array_observers
        observers.each { |obj|
          obj.array_did_change(self, idx, removed, added)
        }
      end

      attribute_did_change :size
      attribute_did_change :content
      attribute_did_change :empty?
    end

    def add_array_observer(obj)
      (@array_observers ||= []) << obj
    end

    def <<(obj)
      length = @content.length
      @content << obj

      array_content_did_change length, 0, 1
      self
    end

    def delete(obj)
      if idx = @content.index(obj)
        @content.delete_at idx
        array_content_did_change idx, 1, 0
      end

      obj
    end

    def insert(idx, obj)
      if idx > @content.length
        raise ArgumentError, 'out of range'
      end

      @content.insert idx, obj
      array_content_did_change idx, 0, 1

      self
    end

    def clear
      length = @content.length
      @content.clear

      array_content_did_change 0, length, 0
      self
    end

    def concat(other_array)
      raise ArgumentError, 'must be Array' unless other_array.is_a? Array
      length = @content.length
      @content.concat other_array

      array_content_did_change length, 0, other_array.length
      self
    end

    alias push <<
  end
end
