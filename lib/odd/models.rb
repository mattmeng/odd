require 'odd/database'
require 'odd/model'
require 'active_support/inflector'

module Odd
  class Models
    def self.object_path
      dir = File.join( Odd::Database.object_path(), self.to_s.downcase.demodulize )
      Dir.mkdir( dir ) unless File.directory?( dir )
      return dir
    end

    def self.set_model( model )
      return @@model = model
    end

    def self.find( uuid: nil )
      return @@model.from_json( File.read( File.join( Odd::Database.instance.object_path, @uid ) ) ) if uuid
      return nil
    end

    def self.where( *args )

    end
  end
end
