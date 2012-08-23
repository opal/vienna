describe "Vienna::Core.add" do
  before do
    @cls = Class.new do
      include Vienna::Model

      field :name
      field :age, type: String
    end

    @cls.add(name: 'Adam Beynon', id: 1)
    @cls.add(name: 'Freddy', id: 2)
  end

  it "makes the model findable through the model id map" do
    @cls.id_map[1].name.should == 'Adam Beynon'
    @cls.id_map[2].name.should == 'Freddy'
  end

  it "adds many models if an array of models is passed in" do
    @cls.add(
      {name: 'Foo', id: 51},
      {name: 'Bar', id: 52},
      {name: 'Baz', id: 53}
    )

    @cls.id_map[51].name.should == 'Foo'
  end
end