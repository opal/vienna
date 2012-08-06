module Vienna

  class Binding

    # The up to date value of the binding. Once a binding is synced,
    # this will be the value that both attributes should be on their
    # objects.
    attr_reader :value

    def initialize(source, s_attr, target, t_attr)
      @source = source
      @s_attr = s_attr
      @target = target
      @t_attr = t_attr
      @value  = nil

      source.observe(s_attr) do |new_val|
        if new_val != @value
          @value = new_val
          target.set_attribute t_attr, @value
        end
      end

      target.observe(t_attr) do |new_val|
        if new_val != @value
          @value = new_val
          source.set_attribute s_attr, @value
        end
      end

      # initial value of source
      @value = source.get_attribute s_attr

      # only set on target if it isn't the same as current value
      unless target.get_attribute(t_attr) == @value
        target.set_attribute t_attr, @value
      end
    end

  end
end