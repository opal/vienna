require 'vienna/attributes'
require 'vienna/persistence'
require 'vienna/eventable'

module Vienna
  class Model
    include Attributes
    include Persistence

    include Eventable
    extend Eventable

    primary_key :id

    attr_accessor :id

    def initialize(attributes = nil)
      @attributes = {}
      @new_record = true
      @loaded     = false

      self.attributes = attributes if attributes
    end

    def self.from_form(form)
      attrs = {}
      `#{form}.serializeArray()`.each do |field|
        key, val = `field.name`, `field.value`
        attrs[key] = val
      end
      new attrs
    end

    def as_json
      json = {}
      json[:id] = self.id if self.id

      self.class.columns.each { |name| json[name] = __send__(name) }
      json
    end

    def to_json
      as_json.to_json
    end

    def trigger_events(name)
      self.class.trigger(name, self)
      self.trigger(name)
    end
  end
end

