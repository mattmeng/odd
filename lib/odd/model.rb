require 'securerandom'
require 'odd/jsonable'
require 'odd/models'
require 'odd/exceptions'
require 'active_support/inflector'

module Odd
  class Model
    include JSONable

    class NoObjectFound < OddException; end
    class NoFactoryClassFound < OddException; end
    class InvalidAttributeName < OddException; end

    attr_reader :uuid

    @@attribute_defaults = {}

    def initialize( file: nil )
      if file
        raise NoObjectFound unless File.exists?( file )
        self.from_json!( File.read( file ) )
      else
        begin
          @uuid = SecureRandom.uuid
        end while File.exists?( object_path() )

        # Set default values.
        @@attribute_defaults.each {|key, value| instance_variable_set( "@#{key}", value )}
      end
    end

    def object_path
      factory = self.class.to_s.pluralize.constantize
      return File.join( factory.object_path(), @uuid )
    rescue NameError => e
      raise NoFactoryClassFound.new
    end

    def save
      File.write( object_path(), self.to_json() )
    end

    def to_json( exclude: [] )
      return super( exclude: [:object_path] + exclude )
    end

    def self.attribute( attribute_name, default: nil, permissions: :rw )
      attribute_name = attribute_name.to_sym
      raise InvalidAttributeName if attribute_name == :uuid or attribute_name == :object_path

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
