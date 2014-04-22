require 'active_support/inflector'

module IdobataGateway
  module Strategies
    class StrategyNotFound < StandardError
      def initialize(name)
        super "Could not find a strategy with name `#{name}'."
      end
    end

    class << self
      def find(name)
        name       = class_name_for name
        class_name = constants.find {|n| n.to_s == name } or raise StrategyNotFound.new(name)
        klass      = const_get class_name

        raise StrategyNotFound.new(name) unless klass <= Base

        klass
      end

      def registrations
        @registrations ||= {}
      end

      def register(name, options = {})
        registrations[name.to_s] = options.fetch(:as, name).to_s
      end

      def class_name_for(name)
        registrations[name.to_s] || name.to_s.camelize
      end
    end
  end
end

Dir[File.join(File.dirname(__FILE__), 'strategies', '*.rb')].each do |file|
  require file
end