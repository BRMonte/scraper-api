class Scrape
  require "nokogiri"
  require "httparty"

  def initialize(url, fields)
    @url = url
    @fields = fields
  end

  def scrape_data
    response_body = fetch_response
    document = parse_document(response_body)
    extract_data(document)
  end

  private

  def fetch_response
    Rails.cache.fetch(@url) do
      fetch_url
    end
  end

  def fetch_url
    HTTParty.get(@url).body
  end

  def parse_document(body)
    Nokogiri::HTML(body)
  end

  def extract_data(document)
    @fields.each_with_object({}) do |(key, selector), result|
      result[key] = extract_field(document, selector) if valid_selector?(selector)
    end
  end

  def extract_field(document, selector)
    document.css(selector).text.strip
  end

  def valid_selector?(selector)
    selector.is_a?(String) && !selector.empty?
  end
end
