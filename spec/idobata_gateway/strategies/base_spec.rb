require 'spec_helper'

describe IdobataGateway::Strategies::Base do
  it "should create payload from params" do
    app      = MockApplication.new(params: {nyan: 'nyan'})
    strategy = described_class.new(app, 'hook_id')

    expect(strategy.payload).to include(nyan: 'nyan')
  end

  it "should create payload from request.env['rack.input']" do
    app      = MockApplication.new(content_type: 'application/json', input: '{"nyan": "nyan"}')
    strategy = described_class.new(app, 'hook_id')

    expect(strategy.payload).to include(nyan: 'nyan')
  end

  it "should request with :hook_id" do
    app      = MockApplication.new(params: {nyan: 'nyan'})
    strategy = described_class.new(app, ':hook_id')
    stub     = stub_request(:post, 'https://idobata.io/hook/:hook_id')

    strategy.execute

    expect(stub).to have_been_requested
  end
end