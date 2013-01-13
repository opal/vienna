require "spec_helper"

describe Vienna::Columns do
  describe ".add_column" do
    before do
      @klass = Class.new(Vienna::Model) do
        add_column :foo
      end
    end

    it "creates a getter and setter method for the column name" do
      @klass.new.respond_to?(:foo).should be_true
      @klass.new.respond_to?(:foo=).should be_true
    end

    it "uses the defined setter to set the attribute" do
      model = @klass.new
      model.foo = 'hello'
      model.foo.should == 'hello'
      model.foo = 'world'
      model.foo.should == 'world'
    end
  end

  describe ".boolean" do
    it "creates a getter and setter for the given attribute name" do
      klass = Class.new(Vienna::Model) { boolean :logged_in }
      klass.new.respond_to?(:logged_in).should be_true
      klass.new.respond_to?(:logged_in=).should be_true
    end
  end

  describe ".date" do
    it "creates a getter and setter for the given attribute name" do
      klass = Class.new(Vienna::Model) { date :last_seen }
      klass.new.respond_to?(:last_seen).should be_true
      klass.new.respond_to?(:last_seen=).should be_true
    end
  end

  describe ".float" do
    it "creates a getter and setter for the given attribute name" do
      klass = Class.new(Vienna::Model) { float :distance }
      klass.new.respond_to?(:distance).should be_true
      klass.new.respond_to?(:distance=).should be_true 
    end
  end

  describe ".integer" do
    it "creates a getter and setter for the given attribute name" do
      klass = Class.new(Vienna::Model) { integer :post_count }
      klass.new.respond_to?(:post_count).should be_true
      klass.new.respond_to?(:post_count=).should be_true
    end
  end

  describe ".string" do
    it "creates a getter and setter for the given attribute name" do
      klass = Class.new(Vienna::Model) { string :user_name }
      klass.new.respond_to?(:user_name).should be_true
      klass.new.respond_to?(:user_name=).should be_true
    end
  end

  describe ".time" do
    it "creates a getter and setter for the given attribute name" do
      klass = Class.new(Vienna::Model) { time :joined_at }
      klass.new.respond_to?(:joined_at).should be_true
      klass.new.respond_to?(:joined_at=).should be_true
    end
  end
end
