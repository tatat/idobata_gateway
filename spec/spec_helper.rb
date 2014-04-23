require 'webmock/rspec'

require File.expand_path('../../lib/idobata_gateway', __FILE__)

Dir[File.expand_path('../support', __FILE__) + '/**/*.rb'].each {|f| require f }