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
    def create_record(record, &block)
      url = record_url(record)
      options = { dataType: "json", payload: record.as_json }
      HTTP.post(url, options) do |response|
        if response.ok?
          record.load response.json
          record.class.trigger :ajax_success, response
          record.did_create
          record.class.trigger :change, record.class.all
        else
          record.trigger_events :ajax_error, response
        end
      end

      block.call(record) if block
    end

    def update_record(record, &block)
      url = record_url(record)
      options = { dataType: "json", payload: record.as_json }
      HTTP.put(url, options) do |response|
        if response.ok?
          record.class.load response.json
          record.class.trigger :ajax_success, response
          record.did_update
          record.class.trigger :change, record.class.all
        else
          record.trigger_events :ajax_error, response
        end
      end

      block.call(record) if block
    end

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

    def find(record, id)
      # TODO remote fetch
      nil
    end

    def fetch(model, options = {}, &block)
      id = options.fetch(:id, nil)
      params = options.fetch(:params, nil)
      url = id ? "#{record_url(model)}/#{id}" : record_url(model)
      options = { dataType: "json", data: params }.merge(options)
      HTTP.get(url, options) do |response|
        if response.ok?
          response.json.each { |record| model.load record }
          model.trigger :ajax_success, response
          model.trigger :refresh, model.all
        else
          model.trigger :ajax_error, response
        end
      end

      block.call(model.all) if block
    end

    def record_url(record)
      return record.to_url if record.respond_to? :to_url
      return record.url if record.respond_to? :url

      if klass_url = record.class.url
        klass_url += "/#{record.id}" unless record.id.nil? or record.id.empty?
        return klass_url
      end

      raise "Model does not define REST url: #{record}"
    end
  end
end
