module Doppler
  class DataTypeMapper
    
    def clean_column_names
      puts "TODO - handle column-name oddities"
    end

    # this mapping is not exhaustive. will add move in the future
    # using this as a reference: https://www.flydata.com/resources/flydata-sync/data-type-mapping/
    def data_type_mapper(mysql_data_type)
      case 
        mysql_data_type
      when /^int\([0-9]+\)/ || "mediumint"
        "integer"
      when /tinyint\([2-9]+\)/
        "smallint"
      when "tinyint(1)"
        "boolean"
      when /float/
        "real"
      when "double"
        "double precision"
      when /text/ || "clob" || "blob"
        "varchar(65535)"
      when /^char\([0-9]+\)/
        "varchar(#{mysql_data_type.scan(/[0-9]/).join})"
      when "datetime"
        "timestamp"
      else
        mysql_data_type
      end
    end

    def from_mysql(table_description)
      table_description.map do |val|
        {:name => val["Field"], :type => data_type_mapper(val["Type"]), :encoding => "", :sort => "", :distribute => ""}
      end
    end

    def create_schema(table_description)
        { 
          :table_name => "", 
          :sort_style => "", 
          :distribution_style => "",
          :fields => from_mysql(table_description)
        }
    end

  end
end
