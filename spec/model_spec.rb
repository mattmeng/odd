require 'spec_helper'
require 'odd/model'

describe Odd::Model do
  context 'variables' do
    let( :obj ) do
      Odd::Model.var :integer, default: 1
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
end
