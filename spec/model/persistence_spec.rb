require 'spec_helper'

describe Vienna::Model do

  before { SimpleModel.reset! }

  let(:model) { SimpleModel.new }

  describe "#did_destroy" do
    it "triggers a :destroy event on the record" do
      called = false
      model.on(:destroy) { called = true }
      model.did_destroy
      called.should eq(true)
    end

    it "triggers a :destroy event on the class" do
      called = false
      SimpleModel.on(:destroy) { called = true }
      model.did_destroy
      called.should eq(true)
    end

    it "removes the record from the class identity_map" do
      model = SimpleModel.load(:first_name => "Adam", id: 872)

      model.did_destroy
      SimpleModel.identity_map[model.id].should eq(nil)
    end
  end

  describe "#did_create" do
    it "sets @new_record to false" do
      model.did_create
      model.new_record?.should eq(false)
    end

    it "adds record to class identity_map" do
      model.id = 863
      model.did_create
      model.class.identity_map[863].should eq(model)
    end

    it "adds record to class record array" do
      model.class.all.should == []
      model.did_create
      model.class.all.should == [model]
    end

    it "triggers a :create event on the record" do
      called = false
      model.on(:create) { called = true }
      model.did_create
      called.should eq(true)
    end

    it "triggers a :create event on the class" do
      called = false
      model.class.on(:create) { called = true }
      model.did_create
      called.should eq(true)
    end
  end

  describe ".all" do
    it "is a record array of all models" do
      model.class.all.should == []
      model.did_create
      model.class.all.should == [model]
    end
  end
end
