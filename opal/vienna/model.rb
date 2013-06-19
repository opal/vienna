module Vienna
  class Model
    include Eventable
    extend Eventable

    def self.attributes(*attrs)
      attrs.each { |name| attribute name }
    end

    def self.attribute attr_name
      columns << attr_name

      define_method(attr_name) do
        @attributes[attr_name]
      end

      define_method("#{attr_name}=") do |val|
        @attributes[attr_name] = val
        trigger("change_#{attr_name}", self, val)
        val
      end
    end

    def self.columns
      @columns ||= []
    end

    def self.adapter(klass = nil)
      return @adapter = klass.new if klass
      @adapter ||= raise("No adapter for #{self}")
    end

    # Return an array of all models
    def self.all
      identity_map.values
    end

    def self.find(id, &block)
      if record = identity_map[id]
        return record
      end

      record = self.new
      self.adapter.find(record, id, &block)
    end

    def self.load(attributes)
      unless attributes[primary_key]
        raise ArgumentError, "no id (#{primary_key}) given"
      end

      map = identity_map

      if model = map[attributes[primary_key]]
        model.attributes = attributes
      else
        model = self.new attributes
        map[model.id] = model
      end

      model.instance_variable_set :@new_record, false

      model.trigger_events(:load)

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

    def self.primary_key(primary_key = nil)
      primary_key ? @primary_key = primary_key : @primary_key ||= :id
    end

    primary_key :id

    attr_accessor :id

    def self.identity_map
      @identity_map ||= {}
    end

    def initialize(attributes = nil)
      @new_record = true
      @attributes = {}

      self.attributes = attributes if attributes
    end

    def [](attr_name)
      @attributes[attr_name]
    end

    def []=(attr_name, value)
      @attributes[attr_name] = value
    end

    def new_record?
      @new_record
    end

    def as_json
      json = @attributes.clone
      json[:id] = self.id if self.id
      json
    end

    def to_json
      as_json.to_json
    end

    def attributes=(attrs)
      attrs.each do |name, value|
        setter = "#{name}="
        if respond_to? setter
          __send__ setter, value
        else
          instance_variable_set "@#{name}", value
        end
      end
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

    def trigger_events(name)
      self.class.trigger(name, self)
      self.trigger(name)
    end
  end
end

