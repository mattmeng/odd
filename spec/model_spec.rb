require 'spec_helper'
require 'odd/model'
require 'json'

describe Odd::Model do
  let( :database_dir ) { RSpec.configuration.database_dir }

  context 'initialize' do
    it 'can be initialized without a file' do
      expect( Odd::Model.new( object_path: database_dir ).uuid ).to be_a( String )
    end

    it 'can be initialize with a file' do
      file = File.join( database_dir, 'temp' )
      File.write( file, {uuid: 'hello'}.to_json() )
      expect( Odd::Model.new( file: file ).uuid ).to eq( 'hello' )
    end
  end

  context 'variables' do
    let( :obj ) do
      Odd::Model.attribute :integer, default: 1
      obj = Odd::Model.new
    end

    it "can be added" do
      expect( obj.instance_variable_defined?( :@integer ) ).to eq true
      expect( obj.respond_to?( :integer ) ).to eq true
      expect( obj.respond_to?( :integer= ) ).to eq true
    end

    it "can be added with a default" do
      expect( obj.integer ).to eq 1
    end
  end

  context 'save' do
    it 'can save to a file' do
      Odd::Model.attribute :integer, default: 1
      model = Odd::Model.new( object_path: database_dir )
      model.save
      json = JSON.parse( File.read( model.object_path ) )
      expect( model.uuid ).to eq( json['uuid'] )
    end
  end
end
