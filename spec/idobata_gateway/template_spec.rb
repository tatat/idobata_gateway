require 'spec_helper'

describe IdobataGateway::Template do
  describe ".path_for" do
    before { described_class.reset_load_paths }

    it "should not find template and raise error" do
      expect { described_class.path_for 'spec.html.erb' }.to raise_error(IdobataGateway::Template::MissingTemplate)
    end

    it "should find template" do
      described_class.load_paths << File.expand_path('templates', File.dirname(__FILE__))
      expect { described_class.path_for 'spec.html.erb' }.not_to raise_error
    end
  end

  describe "#render" do
    before { described_class.reset_load_paths << File.expand_path('templates', File.dirname(__FILE__)) }

    it "should render ERB" do
      rendered = described_class.new.render 'spec.html.erb'
      expect(rendered).to include('spec.html.erb')
    end

    it "should render Haml" do
      rendered = described_class.new.render 'spec.html.haml'
      expect(rendered).to include('spec.html.haml')
    end
  end
end