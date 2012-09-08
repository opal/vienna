module ViewSpecs
  class ViewA < Vienna::View
  end
  
  class ViewB < Vienna::View
    element '#view_b_id'
  end
  
  class ViewC < Vienna::View
    element '#bad_element_reference'
  end
end

describe Vienna::View do
  describe '#element' do
    it 'is a new div element when no element specified on class' do
      element = ViewSpecs::ViewA.new.element
      element.should be_kind_of(JQuery)
      element.length.should == 1
    end
    
    it 'is the element given to View.element() by id' do
      el = JQuery.parse('<div id="view_b_id"></div>')
      el.append_to_body

      ViewSpecs::ViewB.new.element.id.should == 'view_b_id'
      
      el.remove
    end
    
    it 'is nil when element passed to View.element() doesnt exist' do
      ViewSpecs::ViewC.new.element.length.should == 0
    end
  end
  
  describe '#find' do
    it 'searches for dom elements in the scope of the views element' do
      el = JQuery.parse('<div id="view_b_id"><span class="woosh" id="kapow"></span></div><div id="forty_two"></div>')
      el.append_to_body

      ViewSpecs::ViewB.new.find('.woosh').id.should == 'kapow'
      ViewSpecs::ViewB.new.find('.some_random_class').size.should == 0
      ViewSpecs::ViewB.new.find('#forty_two').size.should == 0
      
      el.remove
    end
  end
end