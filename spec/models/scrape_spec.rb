require 'rails_helper'

RSpec.describe Scrape, type: :model do
  let(:url) { "https://example.com" }
  let(:fields) { { "price" => ".price", "stock" => ".stock" } }
  subject { described_class.new(url, fields) }

  describe "#scrape_data" do
    let(:response_body) { "<html><body><span class='price'>10.00</span><span class='stock'>In stock</span></body></html>" }
    let(:document) { Nokogiri::HTML(response_body) }

    before do
      allow(HTTParty).to receive(:get).with(url).and_return(double(body: response_body))
      allow(Rails.cache).to receive(:fetch).with(url).and_yield
    end

    it "fetches the response body from the URL" do
      expect(subject.send(:fetch_url)).to eq(response_body)
    end

    it "parses the document" do
      expect(subject.send(:parse_document, response_body).to_html).to eq(document.to_html)
    end

    it "extracts data based on the provided fields" do
      expected_data = { "price" => "10.00", "stock" => "In stock" }
      expect(subject.scrape_data).to eq(expected_data)
    end

    it "caches the response" do
      expect(Rails.cache).to receive(:fetch).with(url).and_call_original
      subject.scrape_data
    end

    it "handles invalid selectors gracefully" do
      invalid_fields = { "price" => "", "stock" => nil }
      subject.instance_variable_set(:@fields, invalid_fields)

      expected_data = {}
      expect(subject.scrape_data).to eq(expected_data)
    end
  end
end
