module Vienna
  # Persistence
  module Persistence
    module ClassMethods
      # For a model to be persisted, a storage adapter must be set on
      # the model. This can either be done by the model itself:
      #
      #     store = Vienna::RESTStorage.new
      #
      #     class User
      #       include Vienna::Model
      #     end
      #
      #     User.storage = store
      #
      # Or by the storage:
      #
      #     store.add_model User
      #
      # In a real world running application, the booting process itself
      # will register all model classes with the application's storage
      # adapter, so you don't need to do this yourself.
      #
      # @return [Vienna::BaseStorage]
      attr_accessor :storage
    end

    # @private
    def self.included(base); base.extend ClassMethods; end

    # Returns whether or not this model is new. A model is new if it
    # has not yet been assigned an id. Models are assigned id's when
    # they are retrieved from the server (or saved and returned).
    #
    #   user = User.new name: 'adam'
    #   user.new_record?   # => true
    #
    #   user2 = User.new name: 'ben', id: 2
    #   user2.new_record?  # => false
    #
    # If the model has a custom primary key specified, then that
    # attribute will be used in the check instead of the default `id`.
    #
    # @return [true, false]
    def new_record?
      @new_record
    end
  end
end