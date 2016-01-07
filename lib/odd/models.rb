require 'odd/database'
require 'odd/exceptions'
require 'active_support/inflector'

module Odd
  class Models
    class NoRecordClassFound < OddException; end

    attr_reader :indices

    def initialize
      @indices = []
    end

    def add_index( *attributes )
      @indices |= attributes
    end

    def self.instance
      return @@instance ||= self.new
    end

    def self.add_index( *attributes )
      self.instance
    end

    def self.add_to_indices( obj )

    end

    def self.object_path
      dir = File.join( Odd::Database.object_path(), self.to_s.downcase.demodulize )
      Dir.mkdir( dir ) unless File.directory?( dir )
      index_dir = File.join( dir, 'index' )
      Dir.mkdir( index_dir ) unless File.directory?( index_dir )
      return dir
    end

    def self.model
      return self.to_s.singularize.constantize
    rescue NameError => e
      raise NoRecordClassFound.new
    end

    def self.filter( uuid: nil )
      return model.from_json( File.read( File.join( object_path, uuid ) ) ) if uuid
      return nil
    end
  end
end
