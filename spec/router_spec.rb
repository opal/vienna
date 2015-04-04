require 'spec_helper'

describe Vienna::Router do
  describe "#update" do
    it "should update Router.path" do
      $global.location.hash = "#/hello/world"
      subject.update

      subject.path.should eq('/hello/world')
    end

    it "calls #match with the new @path" do
      $global.location.hash = "#/foo/bar"
      called = nil

      subject.define_singleton_method(:match) { |m| called = m }
      called.should be_nil

      subject.update
      called.should eq("/foo/bar")
    end
  end

  describe "#route" do
    it "should add a route" do
      subject.route('/users') {}
      subject.routes.size.should eq(1)

      subject.route('/hosts') {}
      subject.routes.size.should eq(2)
    end
  end

  describe "#match" do
    it "returns nil when no routes on router" do
      subject.match('/foo').should be_nil
    end

    it "returns a matching route for the path" do
      a = subject.route('/foo') {}
      b = subject.route('/bar') {}

      subject.match('/foo').should eq(a)
      subject.match('/bar').should eq(b)
    end

    it "returns nil when there are no matching routes" do
      subject.route('/woosh') {}
      subject.route('/kapow') {}

      subject.match('/ping').should be_nil
    end

    it "calls handler of matching route" do
      out = []
      subject.route('/foo') { out << :foo }
      subject.route('/bar') { out << :bar }

      subject.match('/foo')
      out.should eq([:foo])

      subject.match('/bar')
      out.should eq([:foo, :bar])

      subject.match('/eek')
      out.should eq([:foo, :bar])
    end

    it "works with / too" do
      out = []
      subject.route('/') { out << :index }

      $global.location.hash = ""
      subject.update

      $global.location.hash = "#/"
      subject.update

      out.should == [:index, :index]
    end
  end

  describe "#navigate" do
    it "should update location.hash" do
      subject.navigate "foo"
      $global.location.hash.should eq("#foo")
    end

    it "doesn't add poundsign to location.hash if present" do
      subject.navigate "#foo"
      $global.location.hash.should eq("#foo")
    end

    it "triggers the route matchers" do
      called = false
      subject.route("/foo") { called = true }

      subject.navigate("/bar")
      subject.update
      called.should eq(false)

      subject.navigate("/foo")
      subject.update
      called.should eq(true)
    end
  end
end

