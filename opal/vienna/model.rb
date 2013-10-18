require 'vienna/attributes'
require 'vienna/persistence'
require 'vienna/eventable'

module Vienna
  class Model
    include Attributes
    include Persistence
    include Eventable
    extend Eventable

    attr_accessor :id

    def self.from_form(form)
      attrs = {}
      `#{form}.serializeArray()`.each do |field|
        key, val = `field.name`, `field.value`
        attrs[key] = val
      end
      model = new attrs
      if attrs.has_key?(self.primary_key) and ! attrs[self.primary_key].empty?
        model.instance_variable_set('@new_record', false) 
      end
      model
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

    def inspect
      "#<#{self.class.name}: #{self.class.columns.map { |name|
        "#{name}=#{__send__(name).inspect}"
      }.join(" ")}>"
    end
  end
end

