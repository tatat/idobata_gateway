require 'stringio'

class MockApplication
  def initialize(options = {})
    request.content_type      = options[:content_type]
    request.env['rack.input'] = StringIO.new(options[:input]) if options[:input]
    params.merge! options.fetch(:params, {})
  end

  def request
    @request ||= Request.new
  end

  def params
    @params ||= {}
  end

  class Request
    attr_accessor :content_type

    def env
      @env ||= {}
    end
  end
end