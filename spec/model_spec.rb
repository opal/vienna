require 'spec_helper'

describe Vienna::Model do
  describe ".new" do
    it "should set @new_record to true" do
      SimpleModel.new.new_record?.should be_true
    end
  end

  describe ".primary_key" do
    it "should have a default primary key" do
      SimpleModel.primary_key.should eq(:id)
    end

    it "should be changeable" do
      AdvancedModel.primary_key.should eq(:title)
    end
  end

  describe ".load" do
    it "raises an ArgumentError if no id present" do
      lambda {
        SimpleModel.load({})
      }.should raise_error(ArgumentError)
    end

    it "should be able to load models with own primary_key" do
      AdvancedModel.load(title: 100).should be_kind_of(AdvancedModel)
    end

    it "should set @new_record to false on the model" do
      model = SimpleModel.load(id: 42)
      model.new_record?.should be_false
    end

    it "should cache model" do
      SimpleModel[8].should be_nil
      model = SimpleModel.load(id: 8)
      SimpleModel[8].should eq(model)
    end

    it "should update existing models" do
      foo = SimpleModel.load(id: 9, name: 'Adam')
      bar = SimpleModel.load(id: 9, name: 'Beynon')
      foo.should equal(bar)
      foo.name.should eq("Beynon")
    end
  end
end
