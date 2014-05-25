require 'vienna/eventable'
require 'vienna/record_array'

require 'vienna/model/core'
require 'vienna/model/associations'
require 'vienna/model/attributes'
require 'vienna/model/persistence'

module Vienna
  class Model
    include Core
    include Eventable
    include Associations
    include Attributes
    include Persistence

    attr_accessor :id
    attr_writer :loaded
    attr_writer :new_record

    class << self
      attr_reader :all
    end

    def self.reset!
      @all = RecordArray.new
    end

    def self.inherited(base)
      base.reset!
    end

    def self.primary_key(primary_key = nil)
      primary_key ? @primary_key = primary_key : @primary_key ||= :id
    end

    def self.root_key(root_key = nil)
      root_key ? @root_key = root_key : @root_key
    end

    def self.adapter(klass = nil)
      return @adapter = klass.new if klass
      @adapter or raise "No adapter for #{self}"
    end

    def self.cached(id)
      adapter.cached id
    end

    def self.find(id = nil)
      if id.nil?
        find_all
      else
        find_by_id id
      end
    end

    def self.find_by_id(id)
      if model = adapter.cached(id)
        return model
      end

      model = self.new
      adapter.find model, id
    end

    def self.find_all
      raise "Need to find all"
    end

    def self.load(attributes)
      unless id = attributes[primary_key]
        raise ArgumentError, "no id (#{primary_key}) given"
      end

      unless model = cached(id)
        model = self.new
        model.id = id
        adapter.cache[id] = model
        all << model
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

    def load(attributes = nil)
      self.loaded = true
      self.new_record = false

      self.attributes = attributes if attributes

      trigger :load
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
  end
end
