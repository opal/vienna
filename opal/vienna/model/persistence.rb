module Vienna
  module Persistence
    def save
      @new_record ? create : update
    end

    def create
      self.class.adapter.create_record(self).then do
        did_create
      end
    end

    def update(attributes = nil)
      self.attributes = attributes if attributes
      self.class.adapter.update_record self
    end

    def destroy
      self.class.adapter.delete_record self
    end

    def did_destroy
      @destroyed = true
      self.class.adapter.cache[id] = nil
      self.class.all.delete self

      trigger :destroy
    end

    def did_create
      self.new_record = false
      # add_model_for_id model.class, model, id
      self.class.all.push self
    end

    def did_update
      trigger :update
    end
  end
end
