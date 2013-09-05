require 'spec_helper'

describe Vienna::Router do
  let(:router) { Vienna::Router.new }

  describe "#update" do
    it "should update Router.path" do
      $global.location.hash = "#/hello/world"
      router.update

      router.path.should eq('/hello/world')
    end

    it "calls #match with the new @path" do
      $global.location.hash = "#/foo/bar"
      called = nil

      router.define_singleton_method(:match) { |m| called = m }
      called.should be_nil

      router.update
      called.should eq("/foo/bar")
    end
  end

  describe "#route" do
    it "should add a route" do
      router.route('/users') {}
      router.routes.size.should eq(1)

      router.route('/hosts') {}
      router.routes.size.should eq(2)
    end
  end

  describe "#match" do
    it "returns nil when no routes on router" do
      router.match('/foo').should be_nil
    end

    it "returns a matching route for the path" do
      a = router.route('/foo') {}
      b = router.route('/bar') {}

      router.match('/foo').should eq(a)
      router.match('/bar').should eq(b)
    end

    it "returns nil when there are no matching routes" do
      router.route('/woosh') {}
      router.route('/kapow') {}

      router.match('/ping').should be_nil
    end

    it "calls handler of matching route" do
      out = []
      router.route('/foo') { out << :foo }
      router.route('/bar') { out << :bar }

      router.match('/foo')
      out.should eq([:foo])

      router.match('/bar')
      out.should eq([:foo, :bar])

      router.match('/eek')
      out.should eq([:foo, :bar])
    end

    it "works with / too" do
      out = []
      router.route('/') { out << :index }

      $global.location.hash = ""
      router.update

      $global.location.hash = "#/"
      router.update

      out.should == [:index, :index]
    end
  end

  describe "#navigate" do
    it "should update location.hash" do
      router.navigate "foo"
      $global.location.hash.should eq("#foo")
    end

    it "triggers the route matchers" do
      called = false
      router.route("/foo") { called = true }

      router.navigate("/bar")
      router.update
      called.should be_false

      router.navigate("/foo")
      router.update
      called.should be_true
    end
  end
end

