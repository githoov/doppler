require 'yaml'
require 'mysql2'

module Doppler
  class RDSHelper
    
    attr_reader :config
 
    def initialize
      @config   = DeepStruct.new(YAML.load_file(File.join(Dir.home, 'doppler/config/config.yml')))
      @host     = config.source_database.host
      @port     = config.source_database.port
      @database = config.source_database.database
      @username = config.source_database.user
      @password = config.source_database.password
      @mysql    = Mysql2::Client.new(:host => @host, :username => @username, :password => @password, :database => @database, :port => @port)
    end
    
    def describe_table(table_name)
      @mysql.query("describe #{table_name}")
    end    
        
    def dump_table(table_name)
      File.open("#{table_name}_dump.json", 'w') do |stream|
        mysql.query("select * from #{table_name}", :stream => true).each do |row|
          stream.write(row.to_json + ",\n")
        end
      end
    end

  end
end
