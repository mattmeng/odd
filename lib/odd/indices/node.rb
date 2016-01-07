module Odd
  class Node
    include Enumerable

    attr_accessor :data, :uuid, :left, :right

    def initialize( data, uuid )
      @data = data
      @uuid = uuid
    end

    def insert( data, uuid )
      case data <=> @data
      when 0
        return nil
      when 1
        return (@left ? @left.insert( data, uuid ) : @left = Node.new( data, uuid ))
      when -1
        return (@right ? @right.insert( data, uuid ) : @right = Node.new( data, uuid))
      end
    end

    def find( data )
      case data <=> @data
      when 0
        return @uuid
      when 1
        return @left.find( data ) if @left
      when -1
        return @right.find( data ) if @right
      end

      return nil
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
      return balance >= 0
    end

    def each( &block )
      left.each( &block ) if left
      block.call( self )
      right.each( &block ) if right
    end

    def <=>( other_node )
      return data <=> other_node.data
    end

    def ==( data )
      return @data == data
    end

    def save( file )
      @left.save( file ) if @left
      file.write( "#{@data},#{@uuid}\n")
      @right.save( file ) if @right
    end

    def self.load( obj )
      obj = obj.readlines if obj.is_a?( File )

      count = obj.count
      obj2 = obj.slice!( (count / 2)..count )

      data, uuid = obj2.shift.split( ',' )
      rtnval = Node.new( data.to_i, uuid.chomp )
      rtnval.left = Node.load( obj ) if obj.count > 0
      rtnval.right = Node.load( obj2 ) if obj2.count > 0

      return rtnval
    end
  end
end