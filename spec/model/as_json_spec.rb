require 'spec_helper'

class AsJsonSpec < Vienna::Model
  attributes :first_name, :last_name
end

describe Vienna::Model do
  describe "#as_json" do

    let(:model) { AsJsonSpec.new }

    it "returns a hash" do
      model.as_json.should be_kind_of(Hash)
    end

    it "contains only attributes actually present on instance" do
      model.as_json.should eq({})

      model.first_name = "Adam"
      model.as_json.should eq({ "first_name" => "Adam" })

      model.last_name = "Beynon"
      model.as_json.should eq({ "first_name" => "Adam", "last_name" => "Beynon" })
    end

    it "includes the id, if set" do
      model.id = 42
      model.as_json.should eq({ "id" => 42 })
    end
  end
end
