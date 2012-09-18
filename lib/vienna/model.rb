require 'vienna/eventable'

module Vienna
  class Model
    include Eventable
    extend Eventable
    extend Enumerable

    def self.attribute(name)
      define_method(name) { @attributes[name] }
      define_method("#{name}=") { |val| @attributes[name] = val }
    end

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
    
    def initialize(attributes={})
      @attributes = {}

      attributes.each do |name, val|
        __send__ "#{name}=", val if respond_to? "#{name}="
      end
    end

    def [](name)
      @attributes[name]
    end

    def []=(name, value)
      @attributes[name] = value
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