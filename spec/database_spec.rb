require 'spec_helper'
require 'odd/database'

describe Odd::Database do
  context 'initialize' do
    it "can be initializes with a valid path" do
      expect( Odd::Database.new( File.dirname( __FILE__ ) ) ).to be_a Odd::Database
    end

    it 'will return an exception with an invalid path' do
      expect {Odd::Database.new( '' )}.to raise_error( Odd::Database::DatabaseDoesNotExist )
    end
  end

  context 'instance' do
    it 'returns an instance of itself' do
      Odd::Database.class_variable_set( :@@instance, true )
      expect( Odd::Database.instance ).to be true
    end

    it 'raises an exception when there is no instance' do
      Odd::Database.class_variable_set( :@@instance, nil )
      expect {Odd::Database.instance}.to raise_error( Odd::Database::NoOpenDatabase )
    end
  end

  context 'open' do
    it 'opens a database' do
      expect( Odd::Database.open( File.dirname( __FILE__ ) ) ).to be_a Odd::Database
    end
  end
end
