module Vienna

  # A simple module include that allows AJAX CRUD operations in Vienna::Model
  module Ajax

    module ClassMethods
      def url(url = nil)
        url ? @_url = url : @_url
      end

      def from_form(form)
        attrs = {}
        `#{form}.serializeArray()`.each do |field|
          key, val = `field.name`, `field.value`
          attrs[key] = val
        end
        new attrs
      end

      def destroy!(model)
        options = { dataType: "json" }
        url = model.respond_to?(:url) ? model.url : "#{model.class.url}/#{model.id}"
        HTTP.delete(url, options) do |response|
          if response.ok?
            @_id_map.delete(model.id)
            model.class.trigger :ajax_success, response
            model.class.trigger :destroy, self
            model.class.trigger :change, all
          else
            model.class.trigger :ajax_error, response
          end
        end
      end

      def update!(model)
        url = model.respond_to?(:url) ? model.url : nil
        if model.id.nil? or model.id.empty?
          method = 'POST'
          url ||= model.class.url
        else
          method = 'PUT'
          url ||= "#{model.class.url}/#{model.id}"
        end
        options = { dataType: "json", payload: model.as_json }
        handler = Proc.new do |response|
          if response.ok?
            loaded_model = load_json response.body
            loaded_model.instance_variable_set '@new_record', false
            model.class.trigger :ajax_success, response
            if method == 'POST'
              model.class.trigger :create, loaded_model
            else
              model.class.trigger :update, loaded_model
            end
            model.class.trigger :change, all
          else
            model.class.trigger :ajax_error, response
          end
        end
        HTTP.new(url, method, options, handler).send!
      end

      def fetch(options = {})
        id = options.fetch(:id, nil)
        params = options.fetch(:params, nil)
        url = id ? "#{self.url}/#{id}" : self.url
        options = { dataType: "json", data: params }.merge(options)
        HTTP.get(url, options) do |response|
          if response.ok?
            reset!
            loaded_models = load_many_json response.body
            loaded_models.each { |m| m.instance_variable_set '@new_record', false }
            trigger :ajax_success, response
            trigger :refresh, all
          else
            trigger :ajax_error, response
          end
        end
      end
    end

    def self.included(base)
      base.extend ClassMethods
      # find method from Enumerable conflicts with Vienna::Model
      #base.extend Enumerable
      base.include Vienna::Eventable
      base.extend Vienna::Eventable
    end
  end
end
