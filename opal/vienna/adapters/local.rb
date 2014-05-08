require 'promise'
require 'vienna/adapters/base'

module Vienna
  # Adapter using LocalStorage as a backend
  class LocalAdapter < Adapter
    def initialize
      @storage = $global.localStorage
    end

    def create_record(record)
      record.id = unique_id

      record.did_create
      sync_models(record.class)

      Promise.value record
    end

    def update_record(record)
      record.did_update
      sync_models(record.class)

      Promise.value record
    end

    def delete_record(record)
      record.did_destroy
      sync_models record.class

      Promise.value record
    end

    def find_all(klass)
      if data = @storage.getItem(klass.name)
        models = JSON.parse(data).map { |m| klass.load(m) }
        Promise.value models
      end
    end

    # sync all records in given class to localstorage, now!
    def sync_models(klass)
      name = klass.name
      @storage.setItem name, klass.all.to_json
    end

    # generate a new unique id.. just use timestamp for now
    def unique_id
      (Time.now.to_f * 1000).to_s
    end
  end
end
