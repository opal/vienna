require 'spec_helper'
require 'vienna/observable_array'

class ObservableArraySpec
  include Vienna::ObservableArray
end

describe Vienna::ObservableArray do
  let(:klass) { ObservableArraySpec }
  let(:empty) { klass.new }
  let(:foobar) { klass.new([:foo, :bar]) }

  describe ".new" do
    it "takes an optional content" do
      klass.new.content.should == []
      klass.new([1, 2, 3]).content.should == [1, 2, 3]
    end
  end

  describe "#<<" do
    it "pushes each object into the content" do
      empty << :foo
      empty << :bar
      empty << :baz

      empty.content.should == [:foo, :bar, :baz]
    end

    it "generates a change event for starting index and single added item" do
      expect(empty).to receive(:array_content_did_change).once.with(0, 0, 1)
      empty << :some_object

      expect(foobar).to receive(:array_content_did_change).once.with(2, 0, 1)
      foobar << :other_object
    end
  end

  describe "#delete" do
    it "deletes the object from the content array" do
      foobar.delete :foo
      foobar.content.should == [:bar]
    end

    it "notifies observers with single remove object" do
      expect(foobar).to receive(:array_content_did_change).once.with(1, 1, 0)
      foobar.delete :bar
    end

    it "has no effect when object not present" do
      expect(foobar).to_not receive(:array_content_did_change)
      foobar.delete :baz
    end
  end

  describe "#insert" do
    it "adds the object to the content array at specified index" do
      empty.insert 0, :foo
      empty.content.should == [:foo]

      foobar.insert 1, :baz
      foobar.content.should == [:foo, :baz, :bar]
    end

    it "notifies observers with single added object at index" do
      expect(empty).to receive(:array_content_did_change).once.with(0, 0, 1)
      empty.insert 0, :omg

      expect(foobar).to receive(:array_content_did_change).once.with(1, 0, 1)
      foobar.insert 1, :wow
    end

    it "raises an ArgumentError for index out of range" do
      expect { empty.insert 2, :foo }.to raise_error(ArgumentError)
      expect { foobar.insert 90, :foo }.to raise_error(ArgumentError)
    end
  end

  describe "#clear" do
    it "removes all items from the content array" do
      empty.clear
      empty.content.should == []

      foobar.clear
      foobar.content.should == []
    end

    it "notifies observers to remove all existing objects" do
      expect(empty).to receive(:array_content_did_change).once.with(0, 0, 0)
      empty.clear

      expect(foobar).to receive(:array_content_did_change).once.with(0, 2, 0)
      foobar.clear
    end
  end

  describe "#array_content_did_change" do
    it "triggers a :size attribute change" do
      called = false
      empty.add_observer(:size) { called = true }
      empty.clear

      called.should == true
    end

    it "triggers a :content attribute change" do
      called = false
      empty.add_observer(:content) { called = true }
      empty.clear

      called.should == true
    end

    it "triggers a :empty? attribute change" do
      called = false
      empty.add_observer(:empty?) { called = true }
      empty.clear

      called.should == true
    end

    it "notifies each observer added using add_array_observer" do
      observer = double(:observer)
      expect(observer).to receive(:array_did_change).once.with(empty, 0, 0, 0)

      empty.add_array_observer observer

      empty.clear
    end
  end
end
