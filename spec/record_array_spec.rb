require 'spec_helper'
require 'vienna/record_array'

describe Vienna::RecordArray do
  let(:array) { Vienna::RecordArray.new }

  describe "#initialize" do
    it "should have an empty array of records" do
      array.records.should eq([])
    end
  end

  describe "#method_missing" do
    it "should delegate all method calls to @record" do
      array.class.should eq(Array)
    end
  end

  describe "#each" do
    it "should enumerate over array passing each item to block" do
      array.records = [:foo, :bar, :baz]
      result = []
      array.each { |a| result << a }
      result.should eq([:foo, :bar, :baz])
    end
  end

  describe "#size" do
    it "returns the size of the array" do
      array.size.should == 0
      array.records = [1, 2, 3]
      array.size.should == 3
    end
  end

  describe "#length" do
    it "returns the size of the array" do
      array.length.should eq(0)
    end
  end

  describe "#push" do
    it "pushes the object onto the array" do
      array.push :foo
      array.records.should == [:foo]
      array.push :bar
      array.records.should == [:foo, :bar]
    end
  end
end
