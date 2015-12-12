require 'nesty'

module Odd
  class OddException < StandardError
    include Nesty::NestedError
  end
end