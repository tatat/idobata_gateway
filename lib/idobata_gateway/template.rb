require 'erb'
require 'haml'
require 'tilt'

module IdobataGateway
  class Template < Struct.new(:options)
    class MissingTemplate < StandardError
      def initialize(path)
        super "Missing template - #{path}"
      end
    end

    def initialize(options = {})
      options = {
        format:       :html5,
        attr_wrapper: '"'
      }.merge(options)

      super options
    end

    def render(template, locals = {}, &block)
      Tilt.new(self.class.path_for(template), nil, options)
        .render(self, locals, &block)
    end

    class << self
      def path_for(template)
        load_paths.each do |base|
          path = File.join base, template
          return path if File.exists?(path)
        end

        raise MissingTemplate, template
      end

      def load_paths
        @load_paths ||= []
      end
    end

    load_paths << File.expand_path('templates', File.dirname(__FILE__))
  end
end