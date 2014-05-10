require 'spec_helper'

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

    it "binds nil values as empty content" do
      view.name = nil
      view.run_bindings '<div data-bind="name"></div>'
      view.element.text.should == ''
    end

    it "binds the value for input elements" do
      view.name = 'Ford Prefect'
      view.run_bindings '<input data-bind="name" />'

      view.element.value.should == 'Ford Prefect'
      view.name = 'Arthur Dent'
      view.element.value.should == 'Arthur Dent'
    end
  end
end
