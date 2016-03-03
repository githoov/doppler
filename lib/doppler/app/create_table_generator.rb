require 'pg'

module Doppler
  class CreateTableGenerator

    def initialize
      @config   = DeepStruct.new(YAML.load_file(File.join(Dir.home, 'doppler/config/config.yml')))
      @host     = config.target_database.host
      @port     = config.target_database.port
      @database = config.target_database.database
      @username = config.target_database.user
      @password = config.target_database.password
      @redshift = PGconn.connect(host, port, '', '', database, username, password)
    end

    def column_definitions(field_hash)
      encoding = field_hash['encoding'] == '' ? 'raw' : field_hash['encoding']
      "#{field_hash['name']} #{field_hash['type'].upcase} ENCODE #{encoding}"
    end

    def contains_distribution?(field_hash)
      field_hash['distribute']
    end

    def distribution_definition(fields_array, distribution_style)
      distribution_array = fields_array.map{|h| h['name'] if contains_distribution?(h)}
      distribution_style == 'key' ? "DISTKEY(#{distribution_array.join})" : "DISTSTYLE #{distribution_style.upcase}"
    end

    def contains_sort?(field_hash)
      field_hash['sort']
    end

    def sortkey_definition(fields_array, sort_style)
      sort_array = fields_array.map{|h| h['name'] if contains_sort?(h)}
      sory_array_clean = sort_array.compact.length > 1 ? sort_array.compact.join(', '): sort_array.join
      sort_style == "compound" ? "SORTKEY(#{sory_array_clean})" : "INTERLEAVED SORTKEY(#{sory_array_clean})"
    end

    def issue_create_table
      columns = table_data['fields'].map{|x| column_definitions(x)}.join(', ')
      distribution = distribution_definition(table_data['fields'], table_data['distribution_style'])
      sortkeys = sortkey_definition(table_data['fields'], table_data['sort_style'])
      create = "CREATE TABLE #{table_data['table_name']} (#{columns}) #{distribution} #{sortkeys};"
      redshift.exec(create)
    end

  end
end
