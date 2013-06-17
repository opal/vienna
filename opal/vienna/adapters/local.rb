require 'vienna/adapter'
require 'opal-browser/local_storage'

module Vienna

  # Adapter using LocalStorage as a backend
  class LocalAdapter < Adapter

    def create_record(record, &block)
      record.instance_variable_set(:@new_record, false)

      id = unique_id
      record.id = id
      record.class.identity_map[id] = record

      sync_models(record.class)

      record.trigger_events(:create)
    end

    def update_record(record, &block)
      sync_models(record.class)
      record.trigger_events(:update)
    end

    def delete_record(record, &block)
      record.trigger_events(:destroy)
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
