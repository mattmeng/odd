require 'json'

module Odd
  module JSONable
    def self.included( base )
      base.extend( StaticMethods )
    end

    def to_json
      hash = {}
      self.instance_variables.each do |var|
        hash[var.to_s.tr( '@', '' )] = self.instance_variable_get var
      end
      return hash.to_json
    end

    def from_json!( json )
      JSON.load( json ).each do |var, val|
        self.instance_variable_set( "@#{var}", val )
      end
      return self
    end

    module StaticMethods
      def from_json( json )
        return self.new.from_json!( json )
      end
    end
  end
end
