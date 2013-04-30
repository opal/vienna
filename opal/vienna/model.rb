module Vienna
  class Model
    def self.inherited(base)
      base.reset!
    end

    def self.attributes(*attrs)
      attrs.each { |name| column name }
    end

    def self.column(attr_name)
      columns << attr_name
      attr_accessor attr_name
    end

    def self.columns
      @columns ||= []
    end

    # Return an array of all models
    def self.all
      @_id_map.values
    end

    def self.each(&block)
      all.each { |unit| block.call unit }
    end

    def self.find(id)
      @_id_map[id]
    end

    def self.load(attributes)
      model = self.new attributes
      @_id_map[model.id] = model
      model
    end

    def self.load_json(json)
      load Hash.from_native(json)
    end

    def self.load_many(array)
      array.map { |attrs| load attrs } 
    end

    def self.load_many_json(array)
      array.map { |json| load_json json }
    end

    def self.primary_key(primary_key = nil)
      primary_key ? @primary_key = primary_key : @primary_key ||= :id
    end

    def self.reset!
      @_id_map = {}
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

    def new?
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
