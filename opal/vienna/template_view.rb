require 'template'
require 'vienna/view'
require 'vienna/output_buffer'
require 'active_support/core_ext/string'

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
        element.html = _render_template(template)
      end

      after_render
    end

    def _render_template(template)
      @output_buffer = OutputBuffer.new
      instance_exec @output_buffer, &template.body
    end

    def before_render; end

    def after_render; end
  end
end
