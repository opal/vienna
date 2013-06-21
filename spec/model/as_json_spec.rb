require 'spec_helper'

class AsJsonSpec < Vienna::Model
  attributes :first_name, :last_name
end

describe Vienna::Model do

  let(:model) { AsJsonSpec.new }

  describe "#as_json" do
    it "returns a hash" do
      model.as_json.should be_kind_of(Hash)
    end

    it "contains all attributes on model" do
      model.as_json.should == { "first_name" => nil, "last_name" => nil }

      model.first_name = "Adam"
      model.as_json.should eq({ "first_name" => "Adam", "last_name" => nil })

      model.last_name = "Beynon"
      model.as_json.should eq({ "first_name" => "Adam", "last_name" => "Beynon" })
    end

    it "includes the id, if set" do
      model.id = 42
      model.as_json.should eq({ "id" => 42, "first_name" => nil, "last_name" => nil })
    end
  end
end
