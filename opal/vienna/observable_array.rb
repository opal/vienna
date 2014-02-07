require 'vienna/observable'

module ObservableArray
  def self.infect(array)
    class << array
      alias :old_push :<<
      alias :old_clear :clear
      alias :old_insert :insert
    end

    array.extend self
    array.extend Vienna::Observable
  end

  def content
    self
  end

  def array_content_did_change(idx, remove, added)
    if observers = @array_observers
      observers.each do |obj|
        obj.array_did_change(self, idx, remove, added)

      end
    end

    attribute_did_change :size
    attribute_did_change :content
    attribute_did_change :empty?
  end

  def add_array_observer(object)
    (@array_observers ||= []) << object
  end

  def <<(obj)
    size = length
    old_push obj

    array_content_did_change size, 0, 1
    self
  end

  def insert(idx, object)
    if idx > length
      raise ArgumentError, 'out of range'
    end

    old_insert idx, object

    array_content_did_change idx, 0, 1
    self
  end

  def clear
    length = self.length
    old_clear

    array_content_did_change 0, length, 0
    self
  end
end

class Array
  def add_observer(attribute, &blk)
    ObservableArray.infect(self)
    add_observer(attribute, &blk)
  end

  def add_array_observer(object)
    ObservableArray.infect(self)
    add_array_observer(object)
  end
end
