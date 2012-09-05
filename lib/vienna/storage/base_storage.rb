module Vienna
  class BaseStorage
    def self.inherited(base)
      if name = base.name
        name = name.sub(/Storage$/, '').demodulize.underscore
        BaseStorage[name] = base
      end
    end
    
    @subclasses = {}
    def self.[]=(name, klass)
      @subclasses[name] = klass
    end

    def self.[](name)
      @subclasses[name]
    end
    
    # A hash of all model names to their class. Classes can be added
    # using the `#add_model` method.
    #
    #     store = Vienna::BaseStorage.new
    #     store.add_model User
    #     store.add_model Page
    #
    #     store.models
    #     # => { :user => User, :page => Page }
    #
    # In a real world application, the `Dispatcher` for the application
    # will do this automatically.
    #
    # @return Hash<:symbol, Class>
    attr_reader :models
    
    def initialize
      @models = {}
    end
    
    # Register a model with this storage class. For a model to be stored
    # by a subclass of this base store, then it needs to be registered.
    #
    # Registering a model will set that model's storage property to be
    # this instance. Any of the persistence methods on that model or an
    # instance of that model will then be redirected through this
    # storage adapeter.
    #
    #     store = Vienna::BaseStorage.new
    #     store.add_model User
    # 
    #     User.storage
    #     # => store
    #
    # @param [Class] model a model class
    def add_model(model)
      name = model.name.demodulize.underscore
      @models[name] = model
      
      model.storage = self
    end
    
    def load(type, json)
      
    end
  end
end