require 'spec_helper'
require 'odd/indices/node'

describe Odd::Indices::Node do
  let( :legend ) do
    return [
      {key: 0,   values: [0]   },
      {key: 10,  values: [100] },
      {key: 20,  values: [200] },
      {key: 30,  values: [300] },
      {key: 40,  values: [400] },
      {key: 50,  values: [500] },
      {key: 60,  values: [600] },
      {key: 70,  values: [700] },
      {key: 80,  values: [800] },
      {key: 90,  values: [900] },
      {key: 100, values: [1000]}
    ]
  end

  let( :root ) do
    root = Odd::Indices::Node[legend]
  end

  context 'initialize' do
    it 'can initialize with an array' do
      node = Odd::Indices::Node.new( 50, legend )
      expect( node.values ).to eq( legend )
    end

    it 'can initialize with single value' do
      value = 500
      node = Odd::Indices::Node.new( 50, value )
      expect( node.values ).to eq( [value] )
    end

    it 'can be statically initialized with an array of hashes' do
      node = Odd::Indices::Node[legend]
      expect( node.values ).to eq( [500] )
    end
  end

  context 'utility functions' do
    it 'can report the depth of the tree' do
      expect( root.depth ).to eq( 4 )
    end

    it 'can check the balance of the tree in integer form' do
      expect( root.balance ).to be >= 0
      (101..200).each {|x| root << Odd::Indices::Node.new( x, x )}
      expect( root.balance ).to eq( -1 )
    end

    it 'can check the balance of the tree in boolean form' do
      expect( root.balanced? ).to be true
      (101..200).each {|x| root << Odd::Indices::Node.new( x, x )}
      expect( root.balanced? ).to be false
    end

    it 'can iterate with each' do
      array = []
      root.each {|node| array << {key: node.key, values: node.values}}
      expect( array ).to eq( legend )
    end

    it 'returns an array' do
      expect( root.to_a ).to eq( legend )
    end

    context 'left=' do
      it 'sets the left node' do
        left = Odd::Indices::Node.new( 1000, [1000] )
        root.left = left
        expect( root.left ).to equal( left )
      end

      it 'raises an exception when a bad type is passed' do
        expect {root.left = 1}.to raise_exception( ArgumentError )
      end
    end

    context 'right=' do
      it 'sets the right node' do
        right = Odd::Indices::Node.new( 1000, [1000] )
        root.right = right
        expect( root.right ).to equal( right )
      end

      it 'raises an exception when a bad type is passed' do
        expect {root.right = 1}.to raise_exception( ArgumentError )
      end
    end
  end

  context '<< (insertion)' do
    it 'can insert a new, unique node' do
      value = [1000]
      root << Odd::Indices::Node.new( 1000, value )
      expect( root[1000] ).to equal( value )
    end

    it "doesn't insert an already existing node" do
      node = Odd::Indices::Node.new( legend[0][:key], legend[0][:values] )
      rtnval = root << node
      expect( node.object_id ).not_to be( rtnval.object_id )
    end
  end

  context '[] (search)' do
    it 'can find keys with the correct values' do
      legend.each do |hash|
        expect( root[hash[:key]] ).to eq( hash[:values] )
      end
    end

    it 'returns nil if nothing found' do
      expect( root['not here'] ).to be_nil
    end
  end

  context 'comparator functions' do
    let( :other_node ) {Odd::Indices::Node.new( legend[5][:key], legend[5][:values] )}

    context '== (equivalence)' do
      it {expect( root == legend[5][:key] ).to be( true )}
      it {expect( root == legend[0][:key] ).to be( false )}
    end

    context '<=> (spaceship compare)' do
      it {expect( root.left <=> other_node ).to be( -1 )}
      it {expect( root <=> other_node ).to be( 0 )}
      it {expect( root.right <=> other_node ).to be( 1 )}
    end

    context '< (less than)' do
      it {expect( (root < other_node).length ).to be( 5 )}
      it {expect( (other_node < root).length ).to be( 0 )}
    end

    context '<= (less than or equal to)' do
      it {expect( (root <= other_node).length ).to be( 6 )}
      it {expect( (other_node <= root).length ).to be( 1 )}
    end

    context '> (greater than)' do
      it {expect( (root > other_node).length ).to be( 5 )}
      it {expect( (other_node > root).length ).to be( 0 )}
    end

    context '>= (greater than or equal to)' do
      it {expect( (root >= other_node).length ).to be( 6 )}
      it {expect( (other_node >= root).length ).to be( 1 )}
    end
  end
end
