class DeferrableSpec
  include Vienna::Deferrable
end

describe Vienna::Deferrable do
  it 'calls defined callback on #success and errback on #fail' do
    obj = DeferrableSpec.new
    result = []

    obj.callback { |*args|
      result << :callback
      result << args
    }
    
    obj.errback { |*args|
      result << :errback
      result << args
    }

    obj.succeed
    result.should == [:callback, []]

    result = []
    obj.succeed 1, 2, 3
    result.should == [:callback, [1, 2, 3]]

    result = []
    obj.fail
    result.should == [:errback, []]

    result = []
    obj.fail 4, 5, 6
    result.should == [:errback, [4, 5, 6]]
  end

  it 'has no effect when no callback/errback set' do
    obj = DeferrableSpec.new
    
    obj.succeed
    obj.fail
  end
end