module Vienna
  class Collection
    include Enumerable

    def self.model(model = nil)
      model ? @model = model : @model
    end

    attr_reader :id_map

    attr_reader :model

    def initialize
      @model = self.class.model || Vienna::Model
      self.clear
    end

    # Add either a single or an array of models to this collection. The
    # added models should already be instances of the model type for this
    # class (which defaults to `Vienna::Model`).
    #
    #     users.add User.new(name: 'Adam', id: 42)
    #
    # @param [Vienna::Model, Array<Vienna::Model>] models model(s) to add
    def add(models)
      arr = models.is_a?(Array) ? models : [models]

      arr.each do |model|
        model.instance_variable_set :@new_record, false

        id_map[model.id] = model
      end
    end

    # Resets this collection. This will remove any previously stored
    # models.
    def clear
      @id_map = {}
      @length = 0
    end

    def get(id)
      @id_map[id]
    end

    def get!(id)
      @id_map[id] or raise "Not Found"
    end
  end
end