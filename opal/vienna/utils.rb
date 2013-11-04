module Vienna
  module Utils

    # borrowed from Rack::Utils with slight modifications
    # transforms hash keys:
    #
    # 'user[address]' => 'value' becomes 'user' => { 'address' => 'value' }
    # 'user[]' => 'value' becomes 'user' => [ 'value' ]
    #
    def normalize_params(params, name, v = nil)
      name =~ /^[\[\]]*([^\[\]]+)\]*/
      k = $~[1] || ''
      after = $' || ''
      return if k.empty?

      if after == ""
        params[k] = v
      elsif after == "[]"
        params[k] ||= []
        raise TypeError, "expected Array (got #{params[k].class.name}) for param `#{k}'" unless params[k].is_a?(Array)
        params[k] << v
      elsif after =~ /^\[\]\[([^\[\]]+)\]$/ || after =~ /^\[\](.+)$/
        child_key = $~[1]
        params[k] ||= []
        raise TypeError, "expected Array (got #{params[k].class.name}) for param `#{k}'" unless params[k].is_a?(Array)
        if params[k].last.kind_of?(Hash) && !params[k].last.key?(child_key)
          normalize_params(params[k].last, child_key, v)
        else
          params[k] << normalize_params(params.class.new, child_key, v)
        end
      else
        params[k] ||= params.class.new
        raise TypeError, "expected Hash (got #{params[k].class.name}) for param `#{k}'" unless params[k].kind_of?(Hash)
        params[k] = normalize_params(params[k], after, v)
      end

      return params
    end
    module_function :normalize_params

  end
end
