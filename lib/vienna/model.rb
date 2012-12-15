require 'vienna/eventable'
require 'vienna/attributes'
require 'vienna/columns'

module Vienna
  class Model
    include Eventable
    include Attributes
    include Columns
    extend Eventable
    extend Enumerable

    def self.inherited(base)
      base.reset!
    end

    def self.reset!
      @_models = []
    end

    def self.create(attrs={})
      model = self.new attrs
      @_models << model
      trigger :create, model
      model
    end

    def self.destroy(model)
      @_models.delete model
      trigger :destroy, self
    end

    def self.each(&block)
      @_models.each { |m| block.call m }
    end

    def self.primary_key
      :id
    end
    
    def initialize(attributes={})
      @attributes = {}
      @cached_attributes = {}
      @columns = self.class.columns
      @primary_key = self.class.primary_key
      @new_record = true

      self.attributes = attributes
      @attributes[@primary_key] = nil unless @attributes.key?(@primary_key)
    end

    def save
      update
      trigger :save
    end

    def update_attribute(name, value)
      @attributes[name] = value
      save
    end

    ##
    # private methods..

    def destroy
      self.class.destroy self
      trigger :destroy
    end

    def update
      self.class.trigger :update, self
      trigger :update
    end
  end
end