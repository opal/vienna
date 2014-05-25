require 'vendor/jquery'
require 'opal-rspec'
require 'opal-jquery'
require 'vienna'
require 'vienna/template_view'
require 'vienna/reactor'
require 'vienna/dom_compiler'

module ViennaSpecHelper
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

class SimpleModel < Vienna::Model
  adapter Vienna::Adapter
  attribute :name
end

class User < Vienna::Model
  attributes :foo, :bar, :baz
end

class AdvancedModel < Vienna::Model
  adapter Vienna::Adapter
  primary_key :title
end

class ReactorSpec
  include Vienna::Observable

  attr_accessor :name
end

class BoundView < Vienna::View
  include Vienna::Observable

  attr_accessor :name, :loaded

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

