# Load the Sinatra app
require File.dirname(__FILE__) + '/../main'
require 'rspec'
require 'rack/test'
require 'bundler'
Bundler.require(:default, :test)

set :environment, :test


VCR.configure do |c|
  c.cassette_library_dir = 'spec/cassettes'
  c.hook_into :fakeweb
  c.configure_rspec_metadata!
  c.ignore_localhost = true
end

RSpec.configure do |c|
  c.include Rack::Test::Methods
  c.treat_symbols_as_metadata_keys_with_true_values = true
  c.around(:each, :vcr) do |example|
    name = example.metadata[:full_description].split(/\s+/, 2).join("/").downcase.gsub(/\s+/,"_").gsub(/[^\w\/]+/, "_")
    VCR.use_cassette(name, :re_record_interval => 60*60*24*3, :serialize_with => :json ) { example.call }
  end
end

def app
  Sinatra::Application
end

