module Doppler
  class JSONSchemaGenerator

    attr_reader :rds_helper, :data_type_mapper

    def initialize
      @rds_helper       = RDSHelper.new
      @data_type_mapper = DataTypeMapper.new
    end

    def issue_describe(table_name)
      rds_helper.describe_table(table_name)
    end

    def serialize_schema(table_name)
      schema = data_type_mapper.create_schema(issue_describe(table_name))
      File.open("#{table_name}_definition.json", 'w') do |stream|
        stream.write(schema)
      end
    end

  end
end
