require 'spec_helper'

class AsJsonSpec < Vienna::Model
  attributes :first_name, :last_name
end

describe Vienna::Model do

  let(:model) { AsJsonSpec.new }
  let(:attributes) { model.instance_variable_get :@attributes }

  describe "#as_json" do
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

  describe "#to_json" do
    it "returns as_json.to_json" do
      model.to_json.should eq(attributes.to_json)

      model.first_name = "Bob"
      model.to_json.should eq(attributes.to_json)
    end
  end
end
