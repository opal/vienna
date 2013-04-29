require 'vienna/view'
require 'opal-template'

module Vienna
  class TemplateView < View
    def self.template(name = nil)
      if name
        @template = name
      elsif @template
        @template
      elsif name = self.name
        @template = name.sub(/View$/, '').demodulize.underscore
      end
    end

    def render
      before_render

      if template = Template[self.class.template]
        element.html = template.render self
      end

      after_render
    end

    def before_render; end

    def after_render; end
  end
end
