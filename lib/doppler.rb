require 'rubygems'
require 'bundler'
Bundler.require(:default)

DOPPLER_ROOT = File.expand_path('..', File.dirname(__FILE__))
Dir.glob(File.join(DOPPLER_ROOT, 'lib', 'doppler', '**', '*.rb')).each { |f| require  f }

module Doppler

  def self.run!
   rds_helper = RDSHelper.new
   json_schema_generator = JSONSchemaGenerator.new
   puts json_schema_generator.serialize_schema('license')
  end
end
