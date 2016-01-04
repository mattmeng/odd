require 'benchmark'
require 'securerandom'

class Node
  include Enumerable

  attr_accessor :data, :uuid, :left, :right

  def initialize( data, uuid )
    @data = data
    @uuid = uuid
  end

  def insert( data, uuid )
    if data == @data
      return nil
    elsif data < @data
      if @left
        @left.insert( data, uuid )
      else
        @left = Node.new( data, uuid )
      end
    else
      if @right
        @right.insert( data, uuid )
      else
        @right = Node.new( data, uuid)
      end
    end

    return self
  end

  def find( data )
    if data == @data
      return @uuid
    elsif @left and data < @data
      return @left.find( data )
    elsif @right
      return @right.find( data )
    else
      return nil
    end
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
    data <=> other_node.data
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

def print_node( node, leading: '' )
  if node
    puts "#{node.data}: #{node.uuid}"

    if node.left
      print leading + (node.right ?  "\u251C" : "\u2514")
      print_node( node.left, leading: leading + (node.right ? "\u2502" : ' ') )
    end

    if node.right
      print leading + "\u2514"
      print_node( node.right, leading: leading + ' ' )
    end
  end
end

def print_btree( btree = nil, info_only: false )
  unless btree
    puts 'No Tree Yet!'
    return
  end

  puts "Depth: #{btree.depth}\tCount: #{btree.count}\tBalance: #{btree.balanced?}\tMin: #{btree.min.data}\tMax: #{btree.max.data}\n"
  puts print_node( btree ) if btree.count < 100
end

btree = nil
begin
  print_btree( btree )
  print "i = insert, d = delete, f = find, s = save, l = load, b = benchmark, q = quit: "
  input = gets.chomp

  case input
  when 'i'
    print "insert: "
    input = gets.chomp.to_i
    if btree
      btree.insert( input, SecureRandom.uuid )
    else
      btree = Node.new( input, SecureRandom.uuid )
    end
  when 'f'
    print 'find: '
    input = gets.to_i
    uuid = btree.find( input )
    puts (uuid ? uuid : "None Found") + "\n"
  when 's'
    print "file: "
    input = File.expand_path( gets.chomp )
    file = File.open( input, 'w' )
    btree.save( file )
    file.close
  when 'l'
    print "file: "
    input = File.expand_path( gets.chomp )
    file = File.open( input, 'r' )
    btree = Node.load( file )
    file.close
  when 'b'
    print "i = insertion, f = finding, d = deletion, s = saving and loading, q = quit: "
    input = gets.chomp

    case input
    when 'i'
      print "size: "
      input = gets.to_i
      array = [].fill( 0..(input - 1) ) {|i| i}

      Benchmark.bm do |x|
        x.report( "Insert" ) do
          btree = Node.new( 0, SecureRandom.uuid )
          (1..input).each {|x| btree.insert( x, SecureRandom.uuid )}
        end
      end
    when 'f'
      Benchmark.bm do |x|
        x.report( "Find" ) do
          (btree.min.data..btree.max.data).each do |x|
            btree.find( x )
          end
        end
      end
    when 'd'
      Benchmark.bm do |x|
        x.report( "Delete" ) {}
      end
    when 's'
      Benchmark.bm do |x|
        x.report( "Save" ) do
          file = File.open( 'temp', 'w' )
          btree.save( file )
          file.close
        end
        x.report( "Load" ) do
          file = File.open( 'temp', 'r' )
          btree = Node.load( file )
          file.close
        end
      end
    end
    puts " "
  end
end until input == 'q'
