require 'spec_helper'
require 'odd/jsonable'

describe Odd::JSONable do
  let( :obj ) do
    obj = Class.new.include( Odd::JSONable ).new
    obj.instance_variable_set( :@integer, 1 )
    obj.instance_variable_set( :@bool, true )
    obj.instance_variable_set( :@string, "hello world" )
    return obj
  end

  context 'to_json' do
    it 'returns a string of json with the state of the object' do
      expect( obj.to_json ).to eq "{\"integer\":1,\"bool\":true,\"string\":\"hello world\"}"
      obj.instance_variable_set( :@integer, 2 )
      obj.instance_variable_set( :@bool, false )
      obj.instance_variable_set( :@string, "goodbye universe" )
      expect( obj.to_json ).to eq "{\"integer\":2,\"bool\":false,\"string\":\"goodbye universe\"}"
    end

    it 'returns a string of json excluding some attributes' do
      expect( obj.to_json ).to eq "{\"integer\":1,\"bool\":true,\"string\":\"hello world\"}"
      obj.instance_variable_set( :@integer, 2 )
      obj.instance_variable_set( :@bool, false )
      obj.instance_variable_set( :@string, "goodbye universe" )
      expect( obj.to_json( exclude: [:string] ) ).to eq "{\"integer\":2,\"bool\":false}"
    end
  end

  context 'from_json!' do
    it 'overwrites an object with a string of json' do
      obj.from_json!( "{\"integer\":4,\"bool\":false,\"string\":\"kumusta ka\"}" )
      expect( obj.instance_variable_get( :@integer ) ).to eq 4
      expect( obj.instance_variable_get( :@bool ) ).to eq false
      expect( obj.instance_variable_get( :@string ) ).to eq "kumusta ka"
    end
  end

  context 'from_json' do
    it 'creates a new object from a string of json' do
      new_obj = Class.new.include( Odd::JSONable ).from_json( "{\"integer\":5,\"bool\":true,\"string\":\"ingat ka\"}" )
      expect( new_obj.instance_variable_get( :@integer ) ).to eq 5
      expect( new_obj.instance_variable_get( :@bool ) ).to eq true
      expect( new_obj.instance_variable_get( :@string ) ).to eq "ingat ka"
    end
  end
end
