require 'vienna/adapter'

module Vienna
  class Model
    def self.url(url = nil)
      url ? @url = url : @url
    end
  end
end

module Vienna
  # Adapter for a REST backend
  class RESTAdapter < Adapter
    def delete_record(record, &block)
      options = { dataType: "json" }
      url = record_url(record)

      HTTP.delete(url, options) do |response|
        if response.ok?
          record.class.identity_map.delete(record.id)
          record.trigger(:ajax_success, response)
          # delete from local
          record.trigger_events(:destroy)
          # trigger :change?
        else
          # ajax_error?
          record.trigger_events(:error)
        end
      end
    end

    def record_url(record)
      return record.to_url if record.respond_to? :to_url

      if klass_url = record.class.url
        return "#{klass_url}/#{record.id}"
      end

      raise "Model does not define REST url: #{record}"
    end
  end
end

