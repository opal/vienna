require 'spec_helper'

Template.new('template_view_spec') do |buf|
  buf.append "foo"
  buf.append "bar"
  buf.join
end

class ViewSpec < Vienna::View
  template :template_view_spec
end

class SimpleTemplate < Vienna::View
end

class SimplerTemplateView < Vienna::View
  class SubClassView < Vienna::View
  end
end

describe Vienna::View do
  before do
    @view = ViewSpec.new
    @tmpl = Template['template_view_spec']
  end

  describe ".template" do
    it "returns the class name underscored when no name given" do
      SimpleTemplate.template.should == "simple_template"
    end

    it "removes the `View' prefix from class name" do
      SimplerTemplateView.template.should == "simpler_template"
    end

    it "removes any initial module names from class name" do
      SimplerTemplateView::SubClassView.template.should == "sub_class"
    end
  end
end
