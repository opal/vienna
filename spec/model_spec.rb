require 'spec_helper'

describe Vienna::Model do
  describe ".new" do
    it "should set @new_record to true" do
      expect(SimpleModel.new).to be_new_record
    end
  end

  describe ".primary_key" do
    it "should have a default primary key" do
      expect(SimpleModel.primary_key).to eq(:id)
    end

    it "should be changeable" do
      expect(AdvancedModel.primary_key).to eq(:title)
    end
  end

  describe ".load" do
    it "raises an ArgumentError if no id present" do
      expect { SimpleModel.load({}) }.to raise_error(ArgumentError)
    end

    it "should be able to load models with own primary_key" do
      AdvancedModel.load(title: 100).should be_kind_of(AdvancedModel)
    end

    it "should set @new_record to false on the model" do
      model = SimpleModel.load(id: 42)
      expect(model).to_not be_new_record
    end

    it "should cache model" do
      expect(SimpleModel.cached 8).to be_nil
      model = SimpleModel.load(id: 8)

      expect(SimpleModel.cached 8).to eq(model)
    end

    it "saves the model in .all record array" do
      SimpleModel.all.should == []
      model = SimpleModel.load(id: 10)
      SimpleModel.all.should == [model]
    end

    it "should update existing models" do
      foo = SimpleModel.load(id: 9, name: 'Adam')
      bar = SimpleModel.load(id: 9, name: 'Beynon')
      foo.should equal(bar)
      foo.name.should eq("Beynon")
    end
  end

  describe ".load_json" do
    it "should load a model from native json/js object" do
      obj = `{"id": 13, "name": "Bob"}`
      model = SimpleModel.load_json obj
      model.id.should eq(13)
      model.name.should eq("Bob")
    end
  end

  describe ".adapter" do
    it "sets a new instance of the passed adapter as @adapter" do
      klass = Class.new(Vienna::Model) do
        adapter Vienna::Adapter
      end

      klass.instance_variable_get(:@adapter).should be_kind_of(Vienna::Adapter)
    end

    it "returns the adapter set on the model subclass" do
      klass = Class.new(Vienna::Model) { adapter Vienna::Adapter }
      klass.adapter.should be_kind_of(Vienna::Adapter)
    end

    it "raises an error when no adapter set on model subclass" do
      klass = Class.new(Vienna::Model)
      lambda { klass.adapter }.should raise_error(Exception)
    end
  end if false
end
