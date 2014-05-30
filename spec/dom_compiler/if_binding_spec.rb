require 'spec_helper'

describe Vienna::DOMCompiler do
  describe "if binding" do
    let(:view) { BoundView.new }
    let(:html) { %(<div data-bind-if="loaded"></div>) }

    it "hides dom element when initially falsy" do
      view.loaded = false
      view.run_bindings html

      view.element.css(:display).should == 'none'
    end

    it "does not hide dom element when initially truthy" do
      view.loaded = true
      view.run_bindings html

      view.element.css(:display).should_not == 'none'
    end

    it "hides dom element visibility if attribute changes" do
      view.loaded = true
      view.run_bindings html

      view.loaded = false
      view.element.css(:display).should == 'none'
    end
  end
end
