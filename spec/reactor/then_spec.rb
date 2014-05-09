require 'spec_helper'

describe Vienna::Reactor do
  describe "#then" do
    subject { described_class.new(ReactorSpec.new, :name) }

    it "calls a block on resolve" do
      result = nil
      subject.then { |val| result = val }
      subject.resolve :foo

      result.should == :foo
    end

    it "allows more than one block to be added to a reactor" do
      result = []
      subject.then { result << :first }
      subject.then { result << :second }
      subject.resolve :something

      result.should == [:first, :second]
    end
  end
end
