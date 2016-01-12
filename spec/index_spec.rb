require 'spec_helper'
require 'odd/indices/index'

describe Odd::Indices::Index do
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

  let( :index ) {Odd::Indices::Index.new( 'Test', :test, Odd::Indices::Node[legend] )}
  let( :database_dir ) { RSpec.configuration.database_dir }

  before( :all ) { Odd::Database.open( RSpec.configuration.database_dir ) }

  context 'initialize' do
    it {expect( index.models ).to eq( 'tests' )}
    it {expect( index.attribute ).to eq( :test )}
    it {expect( index.root ).not_to be_nil}
  end

  context 'path' do
    it {expect( index.path() ).to be_a( String )}
    it {expect( index.path().length ).not_to be( 0 )}
  end

  context '<< (insertion)' do
    it 'can execute with an array of values' do
      values = [110]
      index << {key: 110, values: values}
      expect( index[110] ).to eq( values )
    end
  end

  context 'utility methods' do
    it 'can rebalance' do
      (1001..1100).each {|x| index << {key: x, values: [x]}}
      expect( index.balanced? ).to be( false )
      expect( index.rebalance!.balanced? ).to be( true )
    end
  end

  context 'saving and loading' do
    after( :each ) {File.delete( index.path() )}
    it 'can save' do
      index.save
      expect( File.exists?( index.path() ) ).to be( true )
    end

    it 'can save a balanced index' do
      index.save!
      expect( File.exists?( index.path() ) ).to be( true )
    end

    it 'can load an index' do
      index.save!
      io = File.open( index.path, 'r' )
      index2 = Odd::Indices::Index.load( io )
      expect( index2 ).to be_a( Odd::Indices::Index )
    end
  end
end
