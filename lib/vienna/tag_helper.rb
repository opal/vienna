module Vienna
  module TagHelper
    def text_field(object, method, options={})
      field = TextField.new(object, method, options)
      field.value = object.__send__(method)
      # FIXME: should add 'field' to 'self' subviews (self is currently rendering view)
      field.render_view(options)
    end
  end
end