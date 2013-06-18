require 'spec_helper'

describe Vienna::Router::Route do
  describe "#initialize" do
    let(:route) { Vienna::Router::Route }

    it "creates a regexp from the given pattern" do
      route.new('foo').regexp.should eq(/^foo$/)
    end

    it "escapes slashes in the pattern" do
      route.new('/foo/bar/').regexp.should eq(/^\/foo\/bar\/$/)
    end

    it "finds named params in pattern" do
      r = route.new('/foo/:bar')
      r.named.should eq(['bar'])

      p = route.new('/:woosh/:kapow')
      p.named.should eq(['woosh', 'kapow'])
    end

    it "finds splatted params in pattern" do
      route.new('/foo/*baz').named.should eq(['baz'])
    end

    it "produces a regexp to match given pattern" do
      route.new('/foo').regexp.match('/bar').should be_nil
      route.new('/foo').regexp.match('/foo').should be_kind_of(MatchData)
    end
  end

  describe "#match" do
    let(:route) { Vienna::Router::Route }

    it "returns false for a non matching route" do
      route.new('/foo').match('/a/b/c').should be_false
    end

    it "returns true for a matching route" do
      route.new('/foo').match('/foo').should be_true
    end

    it "calls block given to #initialize on matching a route" do
      called = false
      route.new('/foo') { called = true }.match('/foo')
      called.should be_true
    end

    it "calls handler with an empty hash for a simple route" do
      route.new('/foo') { |params| params.should eq({}) }.match('/foo')
    end

    it "returns a hash of named params for matching route" do
      route.new('/foo/:first') { |params|
        params.should eq({'first' => '123' })
      }.match('/foo/123')

      route.new('/:first/:second') { |params|
        params.should eq({ 'first' => 'woosh', 'second' => 'kapow' })
      }.match('/woosh/kapow')
     end
  end
end

