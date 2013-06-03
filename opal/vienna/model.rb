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

    # Return an array of all models
    def self.all
      identity_map.values
    end

    def self.find(id)
      identity_map[id]
    end

    def self.load(attributes)
      raise ArgumentError, "no id (#{primary_key}) given" unless attributes[primary_key]

      model = self.new attributes

      identity_map[model.id] = model

      model.instance_variable_set :@new_record, false
      model
    end

    def self.primary_key(primary_key = nil)
      primary_key ? @primary_key = primary_key : @primary_key ||= :id
    end

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
      @primary_key = self.class.primary_key
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
      !!@new_record
    end

    def save
      self.class.update! self
    end

    def destroy
      self.class.destroy! self
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

    def id
      instance_variable_get "@#{@primary_key}"
    end
  end
end
