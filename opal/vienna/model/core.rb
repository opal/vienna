module Vienna
  module Core
    def as_json
      json = {}
      json[:id] = self.id if self.id

      self.class.columns.each do |column|
        json[column] = __send__ column
      end

      if root_key = self.class.root_key
        json = { root_key => json }
      end

      json
    end

    def to_json
      as_json.to_json
    end

    def inspect
      "#<#{self.class.name}: #{self.class.columns.map { |name|
        "#{name}=#{__send__(name).inspect}"
      }.join(" ")}>"
    end
  end
end
