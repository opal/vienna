require 'spec_helper'
require 'vienna/template_view'

Template.new('template_view_spec') do |buf|
  buf.append "foo"
  buf.append "bar"
  buf.join
end

class TemplateViewSpec < Vienna::TemplateView
  template :template_view_spec
end

describe Vienna::TemplateView do
  before do
    @view = TemplateViewSpec.new
    @tmpl = Template['template_view_spec']
  end

  describe "#_render_template" do
    it "returns the rendered content for the template" do
      @view._render_template(@tmpl).should == "foobar"
    end
  end
end
