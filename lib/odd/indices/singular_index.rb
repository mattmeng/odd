require 'odd/indices/index'

module Odd
  class SingularIndex < Index
    class InvalidFileHandle < OddException; end

    attr_reader :model_path
    attr_reader :attribute

    def initialize( model_path, attribute )
      @index = nil
      @model_path = model_path
      @attribute = attribute

      root = File.join( index_path(), 'root' )
      if File.exists?( root )
        root = File.read( root )

      end
    end

    def index_path
      dir = File.join( @model_path, 'index', @attribute )
      Dir.mkdir( dir ) unless File.directory?( dir )
      return dir
    end

    def dump( path )
      path = File.open( path, 'w' ) if path.kind_of?( String )
      raise InvalidFileHandle.new unless path.kind_of?( File )

      Marshal.dump( self, path )
    end
  end
end
