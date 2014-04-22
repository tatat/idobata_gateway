require 'sinatra/base'
require 'idobata_gateway/strategies'

module IdobataGateway
  class Application < Sinatra::Base
    configure do
      set :show_exceptions, false
    end

    helpers do
      def strategy
        IdobataGateway::Strategies.find(params[:strategy]).new(self, params[:hook_id])
      rescue IdobataGateway::Strategies::StrategyNotFound => ex
        halt 404, ex.message
      end
    end

    post '/:strategy/:hook_id' do
      strategy.execute.status
    end

    error do
      request.env['sinatra.error'].message
    end
  end
end