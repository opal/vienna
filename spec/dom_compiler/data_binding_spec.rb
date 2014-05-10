require 'spec_helper'
require 'vienna/dom_compiler'

class BoundView < Vienna::View
  include Vienna::Observable

  attr_accessor :name

  def run_bindings(html)
    self.class.element html
    self.element
    Vienna::DOMCompiler.new self, template_context
  end

  def template_context
    self
  end

  def add_view_observer(object, attribute, observer)
    object.add_observer(attribute, &observer)
  end
end

describe Vienna::DOMCompiler do
  describe "data binding" do
    let(:view) { BoundView.new }

    it "sets initial vallue on the dom element" do
      view.name = "Ford Prefect"
      view.run_bindings '<div data-bind="name"></div>'

      view.element.text.should == "Ford Prefect"
    end

    it "sets updated values on the dom element" do
      view.name = 'Barney'
      view.run_bindings '<div data-bind="name"></div>'

      view.name = 'Charlie'
      view.element.text.should == 'Charlie'

      view.name = 'Danny'
      view.element.text.should == 'Danny'
    end
  end
end
