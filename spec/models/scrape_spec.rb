require 'rails_helper'

RSpec.describe Scrape, type: :model do
  let(:url) { "https://example.com" }
  let(:fields) { { "price" => ".price", "stock" => ".stock", "meta" => [ "keywords", "description" ] } }
  subject { described_class.new(url, fields) }

  describe "#scrape_data" do
    let(:response_body) do
      <<-HTML
      <html>
        <head>
          <meta name="keywords" content="test, scraping">
          <meta name="description" content="A test description">
        </head>
        <body>
          <span class='price'>10.00</span>
          <span class='stock'>In stock</span>
        </body>
      </html>
      HTML
    end

    before do
      allow(HTTParty).to receive(:get).with(url).and_return(double(body: response_body))
      allow(Rails.cache).to receive(:read).with(url).and_return(nil)
      allow(Rails.cache).to receive(:write)
    end

    it "fetches the response body from the URL" do
      expect(subject.send(:fetch_url)).to eq(response_body)
    end

    it "parses the document" do
      document = subject.send(:parse_document, response_body)
      expect(document.to_html).to eq(Nokogiri::HTML(response_body).to_html)
    end

    it "extracts data based on the provided fields" do
      expected_data = { "price" => "10.00", "stock" => "In stock", "meta" => { "keywords" => "test, scraping", "description" => "A test description" } }
      expect(subject.scrape_data).to eq(expected_data)
    end

    it "caches the response" do
      expect(Rails.cache).to receive(:write).with(url, response_body)
      subject.scrape_data
    end

    it "handles invalid selectors gracefully" do
      invalid_fields = { "price" => "", "stock" => nil, "meta" => [ "nonexistent" ] }
      subject.instance_variable_set(:@fields, invalid_fields)

      expected_data = { "meta" => { "nonexistent" => "" } }
      expect(subject.scrape_data).to eq(expected_data)
    end
  end
end
