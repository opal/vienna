module Vienna
  # Very core methods
  module Core
    module ClassMethods

    end

    # @private
    def self.included(base); base.extend ClassMethods; end

    # Create a new instance of this model. The initial attribute
    # values should be passed into this method. It is not a good idea
    # to override `initialize`, but if you do, make sure to call
    # `super`.
    #
    #   Movie.new title: 'My awesome movie'
    #
    # @param [Hash<Symbol, Object>] attrs initial attributes for model
    def initialize(attrs = {})
      @attributes  = {}
      @primary_key = self.class.primary_key
      @fields      = self.class.fields

      @changed_attributes = {}
      @new_record         = true

      self.attributes = attrs
    end
  end
end