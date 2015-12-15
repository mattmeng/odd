require 'odd/exceptions'

module Odd
  class Database
    class DatabaseDoesNotExist < OddException; end
    class NoOpenDatabase < OddException; end

    attr_reader :path

    def initialize( path )
      raise DatabaseDoesNotExist unless File.directory?( path )
      @path = path
    end

    def self.instance
      raise NoOpenDatabase unless class_variable_defined?( :@@instance ) and @@instance
      return @@instance
    end

    def self.open( path )
      return @@instance = self.new( path )
    end
  end
end