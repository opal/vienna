module Vienna
  class CollectionView < View
    def initalize(collection)
      @child_views = []

      @collection = collection
      @collection.add_array_observer self
    end

    def array_did_change(ary, idx, removed, added)
      removed.times { remove_item idx }
      added.times { |count| add_item idx + count }
    end

    def add_item(idx)
      elem = create_child_element idx
      @child_views.insert idx, elem

      if idx == 0
        element.prepend elem
      else
        @child_views[idx - 1].after el
      end
    end

    def remove_item(idx)
      elem = @child_views[idx]
      elem.remove
      @child_views.delete_at idx
    end
  end
end
