require 'spec_helper'

describe Vienna::Router::Route do
  subject { described_class }

  describe "#initialize" do
    it "creates a regexp from the given pattern" do
      subject.new('foo').regexp.should eq(/^foo$/)
    end

    it "escapes slashes in the pattern" do
      subject.new('/foo/bar/').regexp.should eq(/^\/foo\/bar\/$/)
    end

    it "finds named params in pattern" do
      r = subject.new('/foo/:bar')
      r.named.should eq(['bar'])

      p = subject.new('/:woosh/:kapow')
      p.named.should eq(['woosh', 'kapow'])
    end

    it "finds splatted params in pattern" do
      subject.new('/foo/*baz').named.should eq(['baz'])
    end

    it "produces a regexp to match given pattern" do
      subject.new('/foo').regexp.match('/bar').should be_nil
      subject.new('/foo').regexp.match('/foo').should be_kind_of(MatchData)
    end
  end

  describe "#match" do
    it "returns false for a non matching route" do
      subject.new('/foo').match('/a/b/c').should eq(false)
    end

    it "returns true for a matching route" do
      subject.new('/foo').match('/foo').should eq(true)
    end

    it "calls block given to #initialize on matching a route" do
      called = false
      subject.new('/foo') { called = true }.match('/foo')
      called.should eq(true)
    end

    it "calls handler with an empty hash for a simple route" do
      subject.new('/foo') { |params| params.should eq({}) }.match('/foo')
    end

    it "returns a hash of named params for matching route" do
      subject.new('/foo/:first') { |params|
        params.should eq({'first' => '123' })
      }.match('/foo/123')

      subject.new('/:first/:second') { |params|
        params.should eq({ 'first' => 'woosh', 'second' => 'kapow' })
      }.match('/woosh/kapow')
    end

    describe "optional segment" do
      it "can match simple optional segments" do
        route = subject.new('/foo(/bar)')

        expect(route.match('/foo')).to eq(true)
        expect(route.match('/foo/bar')).to eq(true)
        expect(route.match('/foo/baz')).to_not eq(true)
      end

      it "can match a named part inside an optional part" do
        route = subject.new('/foo(/:bar)')
        expect(route.named).to eq(['bar'])
      end

      it "returns set named part to nil when optional part not given" do
        subject.new('/foo(/:bar)') { |params|
          params.should eq({ 'bar' => nil })
        }.match('/foo')
      end

      it "returns correct value for named param inside optional part" do
        subject.new('/foo(/:bar)') { |params|
          params.should eq({ 'bar' => '42' })
        }.match('/foo/42')
      end
    end
  end
end
