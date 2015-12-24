$LOAD_PATH.unshift File.expand_path( '../../lib', __FILE__ )
require 'odd'
require 'securerandom'
require 'fileutils'

RSpec.configure do |config|
  config.add_setting :database_dir

  config.before( :suite ) do
    begin
      dir = File.join( __dir__, SecureRandom.uuid )
      unless File.directory?( dir )
        Dir.mkdir( dir )
        config.database_dir = dir
      end
    end until config.database_dir
  end

  config.after( :suite ) do
    FileUtils.rm_rf( config.database_dir )
  end
end
