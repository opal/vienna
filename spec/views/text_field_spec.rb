describe Vienna::TextField do
  before do
    @view = Vienna::TextField.new
    def @view.element_id; 'hardcoded'; end
  end

  it 'renders the views type and value' do
    @view.render_view.should == '<input id="hardcoded" type="text" value="" />'
    @view.value = 'puppet of masters'
    @view.render_view.should == '<input id="hardcoded" type="text" value="puppet of masters" />'
  end
end