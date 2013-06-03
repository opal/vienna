require 'spec_helper'

describe Vienna::Model do
  describe ".primary_key" do
    it "should have a default primary key" do
      SimpleModel.primary_key.should eq(:id)
    end

    it "should be changeable" do
      AdvancedModel.primary_key.should eq(:title)
    end
  end

  describe ".load" do
    it "should set @new_record to false on the model" do
      model = SimpleModel.load(id: 42)
      model.new_record?.should be_false
    end

    it "should cache model" do
      SimpleModel[8].should be_nil
      model = SimpleModel.load(id: 8)
      SimpleModel[8].should eq(model)
    end
  end
end
