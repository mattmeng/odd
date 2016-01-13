require 'odd/exceptions'

module Odd
  class Database
    class DatabaseDoesNotExist < OddException; end
    class NoOpenDatabase < OddException; end

    OBJECT_DIR = 'objects'
    INDEX_DIR = 'indices'
    ODD_VERSION_FILE = 'odd.version'

    attr_reader :path

    def initialize( path )
      raise DatabaseDoesNotExist unless File.directory?( path )
      @path = path

      Dir.mkdir( object_path() ) unless File.directory?( object_path() )
      Dir.mkdir( index_path() ) unless File.directory?( index_path() )
      File.write( File.join( @path, ODD_VERSION_FILE ), Odd::VERSION )
    end

    def object_path
      return File.join( @path, OBJECT_DIR )
    end

    def index_path
      return File.join( @path, INDEX_DIR )
    end

    def self.instance
      raise NoOpenDatabase unless class_variable_defined?( :@@instance ) and @@instance
      return @@instance
    end

    def self.open( path )
      return @@instance = self.new( path )
    end

    def self.method_missing( method, *args, &block )
      return self.instance.send( method, *args, &block )
    end
  end
end
