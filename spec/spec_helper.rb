require 'vendor/jquery'
require 'opal-rspec'
require 'opal-jquery'
require 'vienna'
require 'vienna/template_view'

class SimpleModel < Vienna::Model
  attribute :name
end

class User < Vienna::Model
  attributes :foo, :bar, :baz
end

class AdvancedModel < Vienna::Model
  primary_key :title
end

module ViennaSpecHelper
  # Add some html to the document for tests to use. Code is added then
  # removed before each example is run.
  #
  #     describe "some feature" do
  #       html "<div>bar</div>"
  #
  #       it "should have bar content" do
  #         # ...
  #       end
  #     end
  #
  # @param [String] html_string html content
  def html(html_string = "")
    html = %Q{<div id="vienna-spec-test-div">#{html_string}</div>}

    before do
      @_spec_html = Element.parse(html)
      @_spec_html.append_to_body
    end

    after do
      @_spec_html.remove
    end
  end
end

RSpec.configure do |config|
  config.extend ViennaSpecHelper

  config.before(:each) do
    SimpleModel.reset!
    AdvancedModel.reset!
  end
end
