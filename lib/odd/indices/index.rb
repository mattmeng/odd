require 'odd/indices/node'
require 'odd/database'
require 'active_support/inflector'

module Odd
  module Indices
    class Index
      class InvalidFileHandle < OddException; end

      attr_reader :model
      attr_reader :attribute
      attr_reader :root

      def initialize( models, attribute )
        @index = nil
        @models = models.to_s.downcase
        @attribute = attribute
        @root = nil
      end

      def path
        dir = File.join( Odd::Database.index_path, @models )
        Dir.mkdir( dir ) unless File.directory?( dir )
        return File.join( dir, @attribute.to_s )
      end

      def <<( key:, values: [] )
        values = [values] unless values.kind_of?( Array )
        obj = Odd::Indices::Node.new( key, values )
        if @root
          @root << obj
        else
          @root = obj
        end

        return self
      end

      def rebalance!
        if @root
          @root = @root.to_a
          @root = Odd::Indices::Node[*@root]
        end

        return self
      end

      def method_missing( method, *args, &block )
        return @root.send( method, *args, &block ) if @root
        raise NoMethodError.new( 'No method #{method}', method )
      end

      def save
        out = File.open( path(), 'w' )
        Marshal.dump( self, out )
        out.close
      end

      def self.load( io )
        io = File.open( io, 'r' ) unless io.kind_of?( File )
        return Marshal.load( io )
      end
    end
  end
end
