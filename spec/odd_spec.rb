require 'spec_helper'

describe Odd do
  it 'has a root directory' do
    expect( Odd::ROOT_DIR ).not_to be nil
  end

  it 'has a version number' do
    expect( Odd::VERSION ).not_to be nil
  end
end
