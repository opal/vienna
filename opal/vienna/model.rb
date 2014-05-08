require 'vienna/eventable'
require 'vienna/record_array'

module Vienna
  class Model
    include Eventable
    extend Eventable

    attr_accessor :id
    attr_writer :loaded
    attr_writer :new_record

    class << self
      attr_reader :identity_map
      attr_reader :all
    end

    def self.reset!
      @identity_map = {}
      @all = RecordArray.new
    end

    def self.inherited(base)
      base.reset!
    end

    def self.attributes(*attributes)
      attributes.each { |name| attribute name }
    end

    def self.attribute(name)
      columns << name
      attr_accessor name
    end

    def self.columns
      @columns ||= []
    end

    def self.primary_key(primary_key = nil)
      primary_key ? @primary_key = primary_key : @primary_key ||= :id
    end

    def self.adapter(klass = nil)
      return @adapter = klass.new if klass
      @adapter || raise("No adapter for #{self}")
    end

    def self.find(id, &block)
      if record = identity_map[id]
        return record
      end

      record = self.new
      self.adapter.find(record, id, &block)
    end

    def self.load(attributes)
      unless id = attributes[primary_key]
        raise ArgumentError, "no id (#{primary_key}) given"
      end

      map = identity_map
      unless model = map[id]
        model = self.new
        model.id = id
        map[id] = model
        self.all << model
      end

      model.load(attributes)

      model
    end

    def self.load_json(json)
      load Hash.new json
    end

    def self.create(attrs = {})
      model = self.new(attrs)
      model.save
      model
    end

    def self.fetch(options = {}, &block)
      reset!
      adapter.fetch(self, options, &block)
    end

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

    def load(attributes = nil)
      self.loaded = true
      self.new_record = false

      self.attributes = attributes if attributes

      trigger_events :load
    end

    def new_record?
      @new_record
    end

    def destroyed?
      @destroyed
    end

    def loaded?
      @loaded
    end

    def save(&block)
      @new_record ? create(&block) : update(&block)
    end

    def create(&block)
      self.class.adapter.create_record(self, &block)
    end

    def update(attributes = nil, &block)
      self.attributes = attributes if attributes
      self.class.adapter.update_record(self, &block)
    end

    def destroy(&block)
      self.class.adapter.delete_record(self, &block)
    end

    # Should be considered a private method. This is called by an adapter when
    # this record gets deleted/destroyed. This method is then responsible from
    # remoing this record instance from the class' identity_map, and triggering
    # a `:destroy` event. If you override this method, you *must* call super,
    # otherwise undefined bad things will happen.
    def did_destroy
      @destroyed = true
      self.class.identity_map.delete self.id
      self.class.all.delete self

      trigger_events(:destroy)
    end

    # A private method. This is called by the adapter once this record has been
    # created in the backend.
    def did_create
      @new_record = false
      self.class.identity_map[self.id] = self
      self.class.all.push self

      trigger_events(:create)
    end

    # A private method. This is called by the adapter when this record has been
    # updated in the adapter. It should not be called directly. It may be
    # overriden, aslong as `super()` is called.
    def did_update
      trigger_events(:update)
    end

    def [](attribute)
      instance_variable_get "@#{attribute}"
    end

    def []=(attribute, value)
      instance_variable_set "@#{attribute}", value
    end

    def attributes=(attributes)
      attributes.each do |name, value|
        setter = "#{name}="
        if respond_to? setter
          __send__ setter, value
        else
          instance_variable_set "@#{name}", value
        end
      end
    end

    def initialize(attributes = nil)
      @attributes = {}
      @new_record = true
      @loaded     = false

      self.attributes = attributes if attributes
    end
  end
end
