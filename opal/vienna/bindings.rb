module Vienna
  class BaseBinding
    def initialize(view, context, node, attr)
      @view = view
      @context = context
      @node = node
      @attr = attr

      setup_binding
    end

    def destroy
      @context.remove_observer @attr, @observer
    end
  end

  class ValueBinding < BaseBinding
    def setup_binding
      observer = proc { |val| value_did_change @node, val }

      @view.add_view_observer(@context, @attr, observer)

      if @attr.include? '.'
        chain = @attr.split '.'
        current = chain.inject(@context) do |o, p|
          o.__send__ p
        end
      else
        current = @context.__send__(@attr)
      end

      value_did_change @node, current
    end

    def value_did_change(node, value)
      `$(node).html(#{value.to_s});`
    end
  end

  class InputBinding < ValueBinding
    def value_did_change(node, value)
      `$(node).val(#{value.to_s})`
    end
  end

  class ActionBinding < BaseBinding
    def setup_binding
      @element = Element.find @node

      @handler = @element.on(:click) do |evt|
        if @context.respond_to? @attr
          @context.__send__ @attr, evt
        else
          raise "Unknown action: #@attr on #@context"
        end
      end
    end

    def destroy
      @element.off :click, @handler
    end
  end

  class HideIfBinding < BaseBinding
    def setup_binding
      @element = Element.find @node

      if @attr.include? '.'
        chain = @attr.split '.'
        current = chain.inject(@context) do |o, p|
          o.__send__ p
        end
      else
        current = @context.__send__(@attr)
      end

      observer = proc { |val| value_did_change @node, val }

      @view.add_view_observer @context, @attr, observer

      value_did_change @node, current
    end

    def value_did_change(node, value)
      @element.toggle(!value)
    end
  end

  class ShowIfBinding < HideIfBinding
    def value_did_change(node, value)
      @element.toggle value
    end
  end

  class EachBinding < BaseBinding
    def setup_binding
      @element = Element.find @node
      @element.empty
    end
  end

  class ViewBinding < BaseBinding
    def setup_binding
      view = @context.__send__ @attr
      view.render
      Element.find(@node) << view.element
    end

    def destroy
      # do nothing?
    end
  end
end
