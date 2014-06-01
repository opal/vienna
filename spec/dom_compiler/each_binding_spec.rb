require 'spec_helper'

describe Vienna::DOMCompiler do
  describe "each binding" do
    let(:view) { BoundView.new }
    let(:html) do
      <<-HTML
        <div data-bind-each="items">
          <span data-bind="name"></span>
        </div>
      HTML
    end

    it "clears all children of dom element for empty array" do
      view.run_bindings html
      view.element.html.should =~ /^\s*$/
    end
  end
end
