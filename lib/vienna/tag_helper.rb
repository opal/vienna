module Vienna
  module TagHelper
    def text_field(object_name, method)
      id     = "#{object_name}_#{method}"
      name   = "#{object_name}[#{method}]"
      object = instance_variable_get("@#{object_name}")
      value  = object.__send__(method)

      text_field_added object, method, id
      "<input id=\"#{id}\" name=\"#{name}\" type=\"text\" value=\"#{value}\" />"
    end

    # Whenever a new text field is added (using `#text_field`) this
    # method will be called. This is a method that is made heavy use of
    # inside `Vienna::View`.
    #
    # A view uses this method to automatically bind textfields to the
    # underlying model so updates to the textfield are binded back to
    # the model so data is automatically saved. This avoids manual
    # binding of data.
    def text_field_added(object, method, element_id)
      # nothing by default...
    end
  end
end