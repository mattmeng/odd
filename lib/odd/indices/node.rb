require 'odd/exceptions'

module Odd
  module Indices
    class Node
      include Enumerable

      attr_reader :key
      attr_reader :values
      attr_reader :left
      attr_reader :right

      def initialize( key, values = [] )
        @key = key
        @values = (values.kind_of?( Array ) ? values : [values])
      end

      def depth
        return ((@left ? left = @left.depth : 0) > (@right ? right = @right.depth : 0) ? left : (right ? right : 0)) + 1
      end

      def balance
        return 0 if (@left == nil) and (@right == nil)

        left_depth = (@left ? @left.balance : 0)
        right_depth = (@right ? @right.balance : 0)
        return -1 if (left_depth == -1) or (right_depth == -1)

        return -1 if (left_depth - right_depth).abs > 1
        return (left_depth > right_depth ? left_depth : right_depth) + 1
      end

      def balanced?
        return balance() >= 0
      end

      def each( &block )
        left.each( &block ) if left
        block.call( self )
        right.each( &block ) if right
      end

      def left=( left )
        raise ArgumentError.new( 'wrong type' ) unless left.kind_of?( Node )
        @left = left
      end

      def right=( right )
        raise ArgumentError.new( 'wrong type' ) unless right.kind_of?( Node )
        @right = right
      end

      def <<( node )
        case node.key <=> @key
        when 0
          return self
        when -1
          return (@left ? @left << node : @left = node)
        when 1
          return (@right ? @right << node : @right =node)
        end
      end

      def []( key )
        case key <=> @key
        when 0
          return @values
        when -1
          return @left[key] if @left
        when 1
          return @right[key] if @right
        end

        return nil
      end

      def <=>( other_node )
        return key <=> other_node.key
      end

      def ==( key )
        return @key == key
      end

      def to_a
        array = []
        self.each {|node| array << {key: node.key, values: node.values}}
        return array
      end

      def self.[]( *right )
        left = right.slice!( 0..(right.length / 2 - 1) )
        root = left.pop

        root = Node.new( root[:key], root[:values] )
        root.left = Node[*left] if left and left.length > 0
        root.right = Node[*right] if right and right.length > 0

        return root
      end
    end
  end
end
