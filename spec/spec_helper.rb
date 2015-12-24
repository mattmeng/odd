$LOAD_PATH.unshift File.expand_path( '../../lib', __FILE__ )
require 'odd'
require 'securerandom'
require 'fileutils'

RSpec.configure do |config|
  config.before( :suite ) do
    begin
      dir = File.join( __dir__, SecureRandom.uuid )
      unless File.directory?( dir )
        Dir.mkdir( dir )
        @database_dir = dir
      end
    end until @database_dir
  end

  config.after( :suite ) do
    FileUtils.rm_rf( @database_dir )
  end
end
