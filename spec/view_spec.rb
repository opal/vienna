module ViewSpecs
  class ViewA < Vienna::View
  end
  
  class ViewB < Vienna::View
  end
  
  class CustomRender < Vienna::View
    def element_id
      'hardcoded'
    end

    def render(renderer)
      renderer << 'hello world'
    end
  end
end

describe Vienna::View do

  describe '.[]' do
    it 'holds a hash of all views by their element_id to view instance' do
      view = ViewSpecs::ViewA.new
      Vienna::View[view.element_id].should == view
    end
  end

  describe '#element_id' do
    it 'creates a unique element_id for the view' do
      a = ViewSpecs::ViewA.new
      b = ViewSpecs::ViewB.new
      
      a.element_id.should be_kind_of(String)
      a.element_id.should_not == b.element_id
      a.element_id.should == a.element_id
    end
  end

  describe '#render_view' do
    it 'renders itself using a ViewRenderer' do
      view = ViewSpecs::CustomRender.new
      str  = view.render_view
      str.should == "<div id=\"hardcoded\">hello world</div>"
    end

    it 'passes any options onto renderer' do
      view = ViewSpecs::CustomRender.new
      str  = view.render_view(src: 'hello.jpg', alt: 'title')
      str.should == "<div id=\"hardcoded\" src=\"hello.jpg\" alt=\"title\">hello world</div>"
    end

    it 'uses the tag_name from the view to determine generated tag' do
      view = ViewSpecs::CustomRender.new
      def view.tag_name; :span; end
      view.render_view.should == "<span id=\"hardcoded\">hello world</span>"
    end
  end
end