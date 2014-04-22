require 'hashie'
require 'json'
require 'faraday'
require 'idobata_gateway/payload'
require 'idobata_gateway/template'

module IdobataGateway
  module Strategies
    class Base
      class << self
        def configuration
          @configuration ||= Hashie::Mash.new
        end

        def configure
          yield configuration
        end

        def endpoint
          "https://idobata.io"
        end

        def path_for(hook_id)
          "/hook/#{hook_id}"
        end
      end

      attr_accessor :app, :hook_id, :payload

      def initialize(app, hook_id)
        self.app     = app
        self.hook_id = hook_id
        self.payload = IdobataGateway::Payload.new(params)
      end

      def endpoint
        self.class.endpoint
      end

      def path
        self.class.path_for hook_id
      end

      def execute
        request build
      end

      def params
        if app.request.content_type == 'application/json'
          JSON.parse app.request.env['rack.input'].read
        else
          app.params
        end
      end

      def build
        render 'base.html.haml'
      end

      def render(template, locals = {}, options = {})
        IdobataGateway::Template.new(options)
          .render(template, locals.merge(payload: payload))
      end

      def request(source)
        conn = Faraday.new(url: endpoint) do |faraday|
          faraday.request :url_encoded
          faraday.adapter Faraday.default_adapter
          yield faraday if block_given?
        end

        conn.post path, {format: 'html', source: source}
      end
    end
  end
end