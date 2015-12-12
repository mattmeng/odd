require 'odd/jsonable'

module Odd
  class Model
    include JSONable

    READ = :r
    WRITE = :w
    READ_WRITE = :rw

    @@var_defaults = {}

    def initialize
      # Set default values
      @@var_defaults.each {|key, value| instance_variable_set( "@#{key}", value )}
    end

    def save
      puts self.to_json
    end

    def self.var( var_name, default: nil, permissions: :rw )
      var_name = var_name.to_sym

      @@var_defaults[var_name] = default

      define_method( "#{var_name}=" ) do |value|
        instance_variable_set( "@#{var_name}", value )
      end

      define_method( var_name ) do
        return instance_variable_get( "@#{var_name}" )
      end
    end
  end
end
