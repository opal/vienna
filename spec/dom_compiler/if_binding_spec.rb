require 'spec_helper'

describe Vienna::DOMCompiler do
  describe "if binding" do
    let(:view) { BoundView.new }

    it "hides dom element when initially falsy" do
      view.loaded = false
      view.run_bindings '<div data-bind-if="loaded"></div>'

      view.element.css(:display).should == 'none'
    end

    it "does not hide dom element when initially truthy" do
      view.loaded = true
      view.run_bindings '<div data-bind-if="loaded"></div>'

      view.element.css(:display).should_not == 'none'
    end

    it "hides dom element visibility if attribute changes" do
      view.loaded = true
      view.run_bindings '<div data-bind-if="loaded"></div>'

      view.loaded = false
      view.element.css(:display).should == 'none'
    end
  end
end
