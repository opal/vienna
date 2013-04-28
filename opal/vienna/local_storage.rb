require 'opal/browser/local_storage'

module Vienna

  # Mixin for saving/getting models from LocalStorage
  module LocalStorage

    module ClassMethods

      def destroy! model
        sync_local!
        trigger :destroy, model
        trigger :change, all
      end

      def update! model
        sync_local!

        if model.new?
          trigger :create, model
        else
          trigger :update, model
        end
      end

      # Syncs all the models for this class to localstorage
      def sync_local!
        Browser::LocalStorage[plural_name] = all.to_json
      end
    end

    # Including LocalStorage just extends the relevant class methods
    # onto the modal class
    def self.included base
      base.extend ClassMethods
    end
  end
end
