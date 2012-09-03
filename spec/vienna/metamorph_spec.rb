describe Vienna::Metamorph do
  describe "#outer_html" do
    it "returns the string of html" do
      morph = Vienna::Metamorph.new('well hello there')

      (/well hello there/ === morph.outer_html).should be_true
    end
  end

  describe "#html=" do
    before do
      @wrapper = JQuery.new(:div)
      @wrapper.append_to_body
    end

    after do
      @wrapper.remove
    end

    it "replaces the inner content to the new html" do
      morph = Vienna::Metamorph.new('well hello there')
      @wrapper.html = morph.outer_html

      (/well hello there/ === morph.outer_html).should be_true

      morph.html = "boooom"
      (/well hello there/ === morph.outer_html).should be_false
      (/boooom/ === morph.outer_html).should be_true
    end
  end
end