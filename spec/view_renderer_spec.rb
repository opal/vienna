describe Vienna::ViewRenderer do
  before do
    @renderer = Vienna::ViewRenderer.new(:div)
  end

  it 'renders basic content' do
    @renderer.to_s == '<div></div>'
  end

  it '#<< adds string content to the renderer' do
    @renderer << 'hello '
    @renderer << 'world'
    @renderer.to_s.should == "<div>hello world</div>"
  end

  it 'can assign the tag an element id' do
    @renderer.id = 'foo'
    @renderer.to_s.should == '<div id="foo"></div>'
  end

  it 'add css classnames with add_class' do
    @renderer.add_class('foo')
    @renderer.to_s.should == '<div class="foo"></div>'

    @renderer.add_class('bar')
    @renderer.to_s.should == '<div class="foo bar"></div>'
  end

  it 'can add any html attribute with #attr' do
    @renderer.attr(:src, 'foo.jpg')
    @renderer.to_s.should == '<div src="foo.jpg"></div>'
  end

  it 'renders any attributes padded to #initialize' do
    renderer = Vienna::ViewRenderer.new(:div, src: 'hello.jpg', alt: 'hey')
    renderer.to_s.should == '<div src="hello.jpg" alt="hey"></div>'
  end

  it 'can contain a mixture of string and html content' do
    @renderer << '<div class="foo">hello</div>'
    @renderer << 'world'
    @renderer.to_s.should == '<div><div class="foo">hello</div>world</div>'
  end

  it 'ensures input tags are self closing' do
    Vienna::ViewRenderer.new(:input).to_s.should == '<input />'
  end
end