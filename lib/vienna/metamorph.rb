require 'vienna/vendor/metamorph'
`var METAMORPH = Metamorph;`

module Vienna
  class Metamorph
    def initialize(content='')
      @morph = `METAMORPH(content)`
    end

    def html=(html)
      `#{@morph}.html(html)`
    end

    def outer_html
      `#{@morph}.outerHTML()`
    end
  end
end