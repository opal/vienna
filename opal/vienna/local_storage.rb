require 'opal/browser/local_storage'

module Vienna

  # Mixin for saving/getting models from LocalStorage
  module LocalStorage

    module ClassMethods

      def destroy! model
        unless model.new?
          @_models.delete model
        end

        sync_local!

        trigger :destroy, model
        model.trigger :destroy

        trigger :change, all
      end

      def update! model

        if model.new?
          model.instance_variable_set :@new_record, false
          @_models << model

          trigger :create, model
        else
          trigger :update, model
          model.trigger :update
        end

        sync_local!
      end

      # Syncs all the models for this class to localstorage
      def sync_local!
        Browser::LocalStorage[plural_name] = all.to_json
      end

      def all
        @_models
      end

      def reset!
        @_models = []
        if data = Browser::LocalStorage[plural_name]
          JSON.parse(data).each do |attrs|
            puts attrs.inspect
            model = new attrs
            model.instance_variable_set :@new_record, false
            @_models << model
          end
        end
      end
    end

    # Including LocalStorage just extends the relevant class methods
    # onto the modal class
    def self.included base
      base.extend ClassMethods
    end
  end
end
