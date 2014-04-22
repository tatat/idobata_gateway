$:.unshift File.expand_path('lib', File.dirname(__FILE__))

require 'idobata_gateway/application'

run IdobataGateway::Application.new