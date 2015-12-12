require 'spec_helper'
require 'odd/database'

describe Odd::Database do
  it "can be initializes with a valid path" do
    expect(  )
  end
  # context 'instance' do
  #   it "adds" do
  #     expect( obj.instance_variable_defined?( :@integer ) ).to eq true
  #     expect( obj.respond_to?( :integer ) ).to eq true
  #     expect( obj.respond_to?( :integer= ) ).to eq true
  #   end

  #   it "can be added with a default" do
  #     expect( obj.integer ).to eq 1
  #   end
  # end
end




require 'odd/exceptions'

module Odd
  class Database
    class DatabaseDoesNotExist < OddException; end
    class NoOpenDatabase < OddException; end

    attr_reader :path

    def initialize( path )
      raise DatabaseDoesNotExist unless File.directory?( path )
      @path = path
    end

    def self.instance
      raise NoOpenDatabase unless class_variable_defined?( :@@instance )
      return @@instance
    end

    def self.open( path )
      return @@instance = self.new( path )
    end
  end
end