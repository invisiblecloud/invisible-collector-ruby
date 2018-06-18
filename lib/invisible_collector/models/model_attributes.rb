module InvisibleCollector
  module ModelAttributes
    def to_h
      instance_variables.each_with_object({}) { |var, hash| hash[var.to_s.delete("@").camelcase(:lower)] = instance_variable_get(var)}
    end

    def to_json
      to_h.to_json
    end
  end
end
