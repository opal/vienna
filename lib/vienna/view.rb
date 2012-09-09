require 'vienna/tag_helper'
require 'vienna/view_rednerer'

module Vienna
  class View
    include Vienna::TagHelper

    @unique_id = 0
    def self.unique_id(view)
      id = "vn-view-#{@unique_id = @unique_id.next}"
      @views[id] = view
      id
    end

    @views = {}
    def self.[](view_id)
      @views[view_id]
    end

    def element
      return @element if @element
    end

    def element_id
      @element_id ||= View.unique_id(self)
    end

    def find(selector)
      @element.find(selector)
    end

    def render(renderer)
      # 1. find template
      # 2. render template **only** if it exists
      # ... no template means this method is a no-op
    end

    def render_view(options={})
      renderer = ViewRenderer.new(tag_name, options)

      renderer.id = element_id
      render(renderer)

      renderer.to_s
    end

    def tag_name
      :div
    end
  end
end