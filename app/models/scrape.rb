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
    cached_response = Rails.cache.read(@url)
    if cached_response
      Rails.logger.info("Cached response: #{cached_response.inspect}")
      return cached_response
    end

    response = fetch_url

    Rails.cache.write(@url, response)
    response
  end

  def fetch_url
    HTTParty.get(@url).body
  end

  def parse_document(body)
    Nokogiri::HTML.parse(body)
  end

  def extract_data(document)
    result = { "meta" => {} }

    @fields.each do |key, selector|
      if key == "meta"
        selector.each do |meta_tag|
          meta_element = document.at("meta[name='#{meta_tag}']")
          result["meta"][meta_tag] = meta_element ? meta_element["content"] : ""
        end
      else
        result[key] = extract_field(document, selector) if valid_selector?(selector)
      end
    end

    result
  end

  def extract_field(document, selector)
    document.css(selector).text.strip.gsub("\n", " ").squeeze(" ")
  end

  def extract_meta_data(document, meta_tags)
    meta_tags.each_with_object({}) do |tag, meta_result|
      meta_element = document.at("meta[name='#{tag}']")
      meta_result[tag] = meta_element ? meta_element["content"] : nil
    end
  end

  def valid_selector?(selector)
    selector.is_a?(String) && !selector.empty?
  end
end
