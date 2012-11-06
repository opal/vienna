describe Vienna::Router do

  it "should exists as class" do
    Vienna::Router.should_not nil
  end

  it "should exists as instance" do
    Vienna::Router.new.should_not nil
  end

  describe "routing" do

    async "should respond to url /users/1" do

      router=Vienna::Router.new
      
      context=self
      router.define do
        page('/users/:id') { context.run_async { params[:id].should == 1 } }
      end

      router.goto('/users/1')
      
    end

    async "/users/name/francesco should redirect to /users/1" do

      router=Vienna::Router.new
      
      context=self
      router.define do
        page('/users/name/francesco') { redirect('/users/1') }
        page('/users/:id') { context.run_async { params[:id].should == 1 } }
      end
      
      router.goto('/users/name/francesco')
      
    end

  end

end

