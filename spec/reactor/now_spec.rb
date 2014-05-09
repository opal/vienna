require 'spec_helper'

describe Vienna::Reactor do
  describe "#now" do
    let(:object) { ReactorSpec.new }
    subject { Vienna::Reactor.new(object, :name) }

    it "returns the current attribute value" do
      object.name = 'Ford'
      subject.now.should == 'Ford'
      object.name = 'Prefect'
      subject.now.should == 'Prefect'
    end
  end
end
