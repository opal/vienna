require 'spec_helper'

describe Vienna::Model do
  describe "#as_json" do
    let(:model) { User.new }

    it "returns a hash" do
      expect(model.as_json).to be_kind_of(Hash)
    end

    it "contains all attributes on model" do
      expect(model.as_json).to eq({ "foo" => nil, "bar" => nil, "baz" => nil })

      model.foo = "Adam"
      expect(model.as_json).to eq({ "foo" => "Adam", "bar" => nil, "baz" => nil })

      model.bar = "Beynon"

      expect(model.as_json).to eq({ "foo" => "Adam", "bar" => "Beynon", "baz" => nil })
    end

    it "includes the id, if set" do
      model.id = 42

      expect(model.as_json).to eq({ "id" => 42, "foo" => nil, "bar" => nil, "baz" => nil })
    end
  end
end
