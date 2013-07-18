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
          record.did_destroy
          record.class.trigger :ajax_success, response
          record.class.trigger :change, record.class.all
        else
          record.class.trigger :ajax_error, response
        end
      end

      block.call(record) if block
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

