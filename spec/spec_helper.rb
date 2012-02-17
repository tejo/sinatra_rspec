# Load the Sinatra app
require File.dirname(__FILE__) + '/../main'
require 'rspec'
require 'rack/test'
require 'vcr'

set :environment, :test


VCR.config do |c|
  c.cassette_library_dir = 'spec/cassettes'
  c.stub_with :fakeweb
  c.ignore_localhost = true
end

RSpec.configure do |c|
  c.include Rack::Test::Methods
  c.treat_symbols_as_metadata_keys_with_true_values = true
  c.around(:each, :vcr) do |example|
    name = example.metadata[:full_description].split(/\s+/, 2).join("/").underscore.gsub(/[^\w\/]+/, "_")
    options = example.metadata.slice(:record, :match_requests_on).except(:example_group)
    VCR.use_cassette(name, options.merge!(:re_record_interval => 60*60*24*3)) { example.call }
  end
end

def app
  Sinatra::Application
end
