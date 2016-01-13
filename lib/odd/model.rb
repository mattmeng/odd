require 'securerandom'
require 'odd/jsonable'
require 'odd/models'
require 'odd/exceptions'
require 'active_support/inflector'

module Odd
  class Model
    include JSONable

    class NoObjectFileFound < OddException; end
    class NoTableClassFound < OddException; end
    class InvalidAttributeName < OddException; end

    attr_reader :uuid

    @@attribute_defaults = {}

    def initialize( file: nil )
      if file
        raise NoObjectFileFound.new( "No object file found at #{file}." ) unless File.exists?( file )
        self.from_json!( File.read( file ) )
      else
        begin
          @uuid = SecureRandom.uuid
        end while File.exists?( object_path() )

        # Set default values.
        @@attribute_defaults.each {|key, value| self.send( "#{key}=".to_sym, value )}
      end
    end

    def object_path
      return File.join( self.class.models.object_path(), @uuid )
    end

    def save
      File.write( object_path(), self.to_json() )
    end

    def self.attribute( attribute_name, default: nil, permissions: :rw )
      attribute_name = attribute_name.to_sym
      raise InvalidAttributeName if attribute_name == :uuid

      @@attribute_defaults[attribute_name] = default

      define_method( "#{attribute_name}=" ) do |value|
        instance_variable_set( "@#{attribute_name}", value )
      end

      define_method( attribute_name ) do
        return instance_variable_get( "@#{attribute_name}" )
      end
    end

    def self.models
      return self.to_s.pluralize.constantize
    rescue NameError => e
      raise NoTableClassFound.new
    end
  end
end
