require 'vienna/adapter'
require 'opal-browser/local_storage'

module Vienna

  # Adapter using LocalStorage as a backend
  class LocalAdapter < Adapter

    def create_record(record, &block)
      record.id = self.unique_id

      record.did_create
      sync_models(record.class)

      block.call(record) if block
    end

    def update_record(record, &block)
      record.did_update
      sync_models(record.class)

      block.call(record) if block
    end

    def delete_record(record, &block)
      record.did_destroy
      sync_models record.class
      block.call(record) if block
    end

    def find_all(klass, &block)
      if data = Browser::LocalStorage[klass.name]
        models = JSON.parse(data).map { |m| klass.load(m) }
        block.call(models) if block
      end
    end

    # sync all records in given class to localstorage, now!
    def sync_models(klass)
      name = klass.name
      Browser::LocalStorage[name] = klass.all.to_json
    end

    # generate a new unique id.. just use timestamp for now
    def unique_id
      (Time.now.to_f * 1000).to_s
    end
  end
end
