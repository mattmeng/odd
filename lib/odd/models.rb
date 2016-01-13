require 'odd/database'
require 'odd/exceptions'
require 'active_support/inflector'

module Odd
  class Models
    class NoRecordClassFound < OddException; end

    attr_reader :indices

    def initialize
      @indices = {}
    end

    def filter( uuid: nil )
      return model.from_json( File.read( File.join( object_path, uuid ) ) ) if uuid
      return nil
    end

    def object_path
      dir = File.join( Odd::Database.object_path(), self.to_s.downcase.demodulize )
      Dir.mkdir( dir ) unless File.directory?( dir )
      index_dir = File.join( dir, 'index' )
      Dir.mkdir( index_dir ) unless File.directory?( index_dir )
      return dir
    end

    def model
      return self.to_s.singularize.constantize
    rescue NameError => e
      raise NoRecordClassFound.new
    end

    def index( name, *attributes )
      raise ArgumentError.new( 'Index name already exists.' ) if @indices.key?( name )
      attributes.each do |attribute|
        raise ArgumentError.new( 'Call to Models.index requires an array of symbols.' ) unless attribute.is_a?( Symbol )
      end

      # @indices[name] =
    end

    def self.instance
      return @@instance ||= self.new
    end

    def self.method_missing( method, *args, &block )
      return self.instance.send( method, *args, &block )
    end
  end
end
