require 'odd/jsonable'

module Odd
  class Model
    include JSONable

    attr_reader :uid

    READ = :r
    WRITE = :w
    READ_WRITE = :rw

    @@attribute_defaults = {}

    def initialize
      begin
        @uid = SecureRandom.uuid
      end while File.exists?( object_path() )

      # Set default values
      @@attribute_defaults.each {|key, value| instance_variable_set( "@#{key}", value )}
    end

    def object_path
      return File.join( Odd::Database.instance.object_path, @uid )
    end

    def save
      File.write( object_path(), self.to_json )
    end

    def self.attribute( attribute_name, default: nil, permissions: :rw )
      attribute_name = attribute_name.to_sym
      raise InvalidAttributeName if attribute_name == :uid

      @@attribute_defaults[attribute_name] = default

      define_method( "#{attribute_name}=" ) do |value|
        instance_variable_set( "@#{attribute_name}", value )
      end

      define_method( attribute_name ) do
        return instance_variable_get( "@#{attribute_name}" )
      end
    end
  end
end
