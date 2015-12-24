require 'odd/exceptions'

module Odd
  class Database
    class DatabaseDoesNotExist < OddException; end
    class NoOpenDatabase < OddException; end

    OBJECT_DIR = '/objects'

    attr_reader :path

    def initialize( path )
      raise DatabaseDoesNotExist unless File.directory?( path )
      @path = path

      Dir.mkdir( object_path() ) unless File.directory?( object_path() )
    end

    def self.instance
      raise NoOpenDatabase unless class_variable_defined?( :@@instance ) and @@instance
      return @@instance
    end

    def self.open( path )
      return @@instance = self.new( path )
    end

    def object_path
      return @path + OBJECT_DIR
    end

    def self.object_path
      return instance.object_path
    end
  end
end
