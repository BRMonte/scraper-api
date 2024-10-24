require 'rails_helper'

RSpec.describe ScrapeSerializer do
  let(:data) do
    {
      "price" => "10.00",
      "stock" => "In stock",
      "meta" => {
        "keywords" => "test, scraping",
        "description" => "A test description"
      }
    }
  end
  let(:fields) { { "price" => true, "stock" => true, "meta" => [ "keywords", "description" ] } }
  subject { described_class.new(data, fields) }

  describe "#serialize" do
    it "serializes the data correctly" do
      expected_result = {
        "meta" => {
          "keywords" => "test, scraping",
          "description" => "A test description"
        },
        "price" => "10.00",
        "stock" => "In stock"
      }
      expect(subject.serialize).to eq(expected_result)
    end

    it "handles missing meta data gracefully" do
      data_with_missing_meta = {
        "price" => nil,
        "stock" => nil,
        "meta" => {}
      }
      subject = described_class.new(data_with_missing_meta, fields)

      expected_result = {
        "meta" => {
          "keywords" => "",
          "description" => ""
        },
        "price" => nil,
        "stock" => nil
      }
      expect(subject.serialize).to eq(expected_result)
    end

    it "returns only specified fields in the result with nil for missing ones" do
      fields_with_only_price = {
        "price" => true
      }
      subject = described_class.new(data, fields_with_only_price)

      expected_result = {
        "meta" => {},
        "price" => "10.00"
      }
      expect(subject.serialize).to eq(expected_result)
    end
  end
end
