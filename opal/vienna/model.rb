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

    def as_json
      json = @attributes.clone
      json[:id] = self.id if self.id
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

