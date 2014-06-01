require 'spec_helper'

class ViewEventSpec < Vienna::View
  on :click, :handle_click
  on :click, '.foo', :handle_selector

  on :click, '.bar' do
    called_block_handler
  end

  def handle_click(*); end
  def handle_selector(*); end
end

describe Vienna::View do
  describe '.on' do
    it "registers a method to handle events on elements" do
      view = ViewEventSpec.new
      expect(view).to receive(:handle_click).once

      view.element.trigger :click
    end

    it "can register events on elements by selector" do
      view = ViewEventSpec.new
      expect(view).to receive(:handle_selector).once
      view.element.html = <<-HTML
        <div class="foo" id="custom-event-selector"></div>
      HTML

      view.element.find(".foo").trigger :click
    end

    it "can register a block as handler for events" do
      view = ViewEventSpec.new
      expect(view).to receive(:called_block_handler).once
      view.element.html = <<-HTML
        <div class="bar"></div>
      HTML

      view.element.find(".bar").trigger :click
    end
  end
end
