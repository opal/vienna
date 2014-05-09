require 'spec_helper'

describe Vienna::Reactor do
  describe ".merge" do
    let(:first) { Vienna::Reactor.new(ReactorSpec.new, :name) }
    let(:second) { Vienna::Reactor.new(ReactorSpec.new, :name) }

    it "resolves when any reactor resolves itself" do
      count = 0

      Vienna::Reactor.merge(first, second).then do
        count += 1
      end

      count.should == 0
      first.resolve('Adam')
      count.should == 1
      second.resolve('Beynon')
      count.should == 2
      first.resolve('Charles')
      count.should == 3
    end
  end
end
