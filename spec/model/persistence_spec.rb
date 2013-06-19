require 'spec_helper'

describe Vienna::Model do

  let(:model) { SimpleModel.new }

  describe "#did_destroy" do
    it "triggers a :destroy event on the record" do
      called = false
      model.on(:destroy) { called = true }
      model.did_destroy
      called.should be_true
    end

    it "triggers a :destroy event on the class" do
      called = false
      SimpleModel.on(:destroy) { called = true }
      model.did_destroy
      called.should be_true
    end

    it "removes the record from the class identity_map" do
      model = SimpleModel.load(:first_name => "Adam", id: 872)

      model.did_destroy
      SimpleModel.identity_map[model.id].should be_nil
    end
  end

  describe "#did_create" do
    it "sets @new_record to false" do
      model.did_create
      model.new_record?.should be_false
    end

    it "adds record to class identity_map" do
      model.id = 863
      model.did_create
      model.class.identity_map[863].should eq(model)
    end

    it "triggers a :create event on the record" do
      called = false
      model.on(:create) { called = true }
      model.did_create
      called.should be_true
    end

    it "triggers a :create event on the class" do
      called = false
      model.class.on(:create) { called = true }
      model.did_create
      called.should be_true
    end
  end
end
