require 'spec_helper'

describe Vienna::View do

  describe "#create_element" do

    html <<-HTML
      <div id="simple_element"></div>
      <div id="parent-element">
        <div id="child-element" class="child"></div>
      </div>

      <div id="child-element-missing"></div>
    HTML

    it "returns the Element instance wraping the selector given to Element.element" do
      klass = Class.new(Vienna::View) do
        element "#simple_element"
      end

      klass.new.create_element.id.should eq("simple_element")
    end

    it "creates a new element with specified tag_name in class when no element defined" do
      klass = Class.new(Vienna::View) do
        def tag_name
          'table'
        end
      end

      klass.new.create_element.tag_name.should eq("table")
    end

    it "creates a new element with specified tag_name with the class method when no element defined" do
      klass = Class.new(Vienna::View) do
        tag_name 'table'
      end

      klass.new.create_element.tag_name.should eq("table")
    end

    it "creates a div element with specified class_name in class when no element defined" do
      klass = Class.new(Vienna::View) do
        def class_name
          'my_class'
        end
      end

      klass.new.create_element.class_name.should eq("my_class")
    end

    it "creates a div element with specified class_name with the class method when no element defined" do
      klass = Class.new(Vienna::View) do
        class_name 'my_class'
      end
      klass.new.create_element.class_name.should eq("my_class")
    end


    describe "with a parent view" do
      it "returns an element found inside the scope of parent element" do
        parent = Class.new(Vienna::View) { element "#parent-element" }.new
        child  = Class.new(Vienna::View) { element "#child-element" }.new

        child.parent = parent
        child.create_element.class_name.should eq("child")
      end

      it "returns an empty element if element selector does not exist in parent scope" do
        parent = Class.new(Vienna::View) { element "#parent-element" }.new
        child  = Class.new(Vienna::View) { element "#child-element-missing" }.new

        child.parent = parent
        child.create_element.size.should eq(0)
      end
    end
  end

  describe "#render" do
    it "returns the view" do
      view = Class.new(Vienna::View).new
      view.render.should eq(view)
    end
  end
end
