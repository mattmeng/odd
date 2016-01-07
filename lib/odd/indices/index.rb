require 'odd/exceptions'

module Odd
  class Index < Hash
    class InvalidFileHandle < OddException; end

    # def self.add_index( )
    def dump( path )
      path = File.open( path, 'w' ) if path.kind_of?( String )
      raise InvalidFileHandle.new unless path.kind_of?( File )

      Marshal.dump( self, path )
    end
  end
end