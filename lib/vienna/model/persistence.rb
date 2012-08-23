module Vienna
  # Persistence
  module Persistence
    module ClassMethods

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