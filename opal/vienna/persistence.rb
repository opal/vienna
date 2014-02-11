require 'vienna/record_array'

module Vienna
  module Persistence
    module ClassMethods
      def adapter(klass = nil)
        return @adapter = klass.new if klass
        @adapter || raise("No adapter for #{self}")
      end

      def identity_map
        @identity_map ||= {}
      end

      # Return a simple array of all models
      def all
        @all ||= RecordArray.new
      end

      def find(id, &block)
        if record = identity_map[id]
          return record
        end

        record = self.new
        self.adapter.find(record, id, &block)
      end

      def load(attributes)
        unless id = attributes[primary_key]
          raise ArgumentError, "no id (#{primary_key}) given"
        end

        map = identity_map
        unless model = map[id]
          model = self.new
          model.id = id
          map[id] = model
          self.all << model
        end

        model.load(attributes)

        model
      end

      def load_json(json)
        load Hash.new json
      end

      def create(attrs = {})
        model = self.new(attrs)
        model.save
        model
      end

      def fetch(options = {}, &block)
        self.reset!
        self.adapter.fetch(self, options, &block)
      end

      def reset!
        @identity_map = @all = nil
      end
    end

    def self.included(klass)
      klass.extend(ClassMethods)
    end

    def load(attributes = nil)
      @loaded, @new_record = true, false
      self.attributes = attributes if attributes

      trigger_events :load
    end

    def new_record?
      @new_record
    end

    def loaded?
      @loaded
    end

    def save(&block)
      @new_record ? create(&block) : update(&block)
    end

    def create(&block)
      self.class.adapter.create_record(self, &block)
    end

    def update(attributes = nil, &block)
      self.attributes = attributes if attributes
      self.class.adapter.update_record(self, &block)
    end

    def destroy(&block)
      self.class.adapter.delete_record(self, &block)
    end

    # Should be considered a private method. This is called by an adapter when
    # this record gets deleted/destroyed. This method is then responsible from
    # remoing this record instance from the class' identity_map, and triggering
    # a `:destroy` event. If you override this method, you *must* call super,
    # otherwise undefined bad things will happen.
    def did_destroy
      self.class.identity_map.delete self.id
      self.class.all.delete self

      trigger_events(:destroy)
    end

    # A private method. This is called by the adapter once this record has been
    # created in the backend.
    def did_create
      @new_record = false
      self.class.identity_map[self.id] = self
      self.class.all.push self

      trigger_events(:create)
    end

    # A private method. This is called by the adapter when this record has been
    # updated in the adapter. It should not be called directly. It may be
    # overriden, aslong as `super()` is called.
    def did_update
      trigger_events(:update)
    end
  end
end

