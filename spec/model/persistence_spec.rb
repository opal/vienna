require 'spec_helper'

describe Vienna::Model do
  let(:model_class) { SimpleModel }
  let(:model) { model_class.new }
  let(:loaded_model) { model_class.load(:first_name => "Adam", id: 872) }
  describe "#did_destroy" do
    it "triggers a :destroy event on the record" do
      called = false
      model.on(:destroy) { called = true }
      model.did_destroy
      called.should eq(true)
    end

    it "triggers a :destroy event on the class" do
      called = false
      model_class.on(:destroy) { called = true }
      model.did_destroy
      called.should eq(true)
    end

    it "removes the record from the class identity_map" do
      loaded_model.did_destroy
      model_class.identity_map[loaded_model.id].should eq(nil)
    end

    it "removes the record from the class record_array" do
      loaded_model.did_destroy
      model_class.all.should_not include(loaded_model)
    end
  end

  describe '#destroyed?' do
    it 'is false for "living" models' do
      model.destroyed?.should be_falsey
    end

    it "is true for destroyed models" do
      loaded_model.did_destroy
      loaded_model.destroyed?.should be_truthy
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
