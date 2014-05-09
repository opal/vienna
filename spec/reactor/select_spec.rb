require 'spec_helper'

describe Vienna::Reactor do
  describe "#select" do
    subject { Vienna::Reactor.new(ReactorSpec.new, :name) }

    it "filters events from the reactor" do
      result = []
      subject.select { |val| val > 10 }.then { |val| result << val }

      subject.resolve 15
      subject.resolve 8
      subject.resolve 22
      subject.resolve 3

      result.should == [15, 22]
    end
  end
end
