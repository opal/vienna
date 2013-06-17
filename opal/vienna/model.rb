module Vienna
  class Model
    include Eventable
    extend Eventable

    def self.attributes(*attrs)
      attrs.each { |name| attribute name }
    end

    def self.attribute attr_name
      columns << attr_name
      attr_accessor attr_name
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
      raise ArgumentError, "no id (#{primary_key}) given" unless attributes[primary_key]

      if model = self[attributes[primary_key]]
        model.attributes = attributes
      else
        model = self.new attributes
        identity_map[model.id] = model
      end

      model.instance_variable_set :@new_record, false
      model
    end

    def self.load_json(json)
      load Hash.new json
    end

    def self.primary_key(primary_key = nil)
      primary_key ? @primary_key = primary_key : @primary_key ||= :id
    end

    primary_key :id

    attr_accessor :id

    def self.identity_map
      @identity_map ||= {}
    end

    def self.[](id)
      identity_map[id]
    end

    def self.[]=(id, model)
      identity_map[id] = model
    end

    def initialize(attrs={})
      @new_record = true
      self.attributes = attrs
    end

    def [](column)
      __send__(column)
    end

    def []=(column, value)
      __send__("#{column}=", value)
    end

    def new_record?
      @new_record
    end

    def as_json
      json = {}

      self.class.columns.each do |column|
        json[column] = __send__(column).as_json
      end

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

    def update(&block)
      self.class.adapter.update_record(self, &block)
    end

    def destroy(&block)
      self.class.adapter.delete_record(self, &block)
    end
  end
end
