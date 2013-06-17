module Vienna

  class << self
    attr_accessor :adapter
  end

  # An adapter is responsible for fetching and saving records from
  # some endpoint. This base class acts as an interface which subclasses
  # should develop. Adapters can be set on a per-model basis, or as an
  # adapter for all models. Example adapter subclasses are RESTAdapter
  # and LocalAdapter. A fixtures adapter is also provided for testing
  # purposes.
  class Adapter

    def find(record, id, &block)

    end

    def load(record, id, &block)

    end

    def create_record(record)

    end

    def save_record(record)

    end

    def delete_record(record)

    end

    def implement(method)
      raise NoMethodError, "Adapter subclass should implement `#{method}'"
    end
  end
end
