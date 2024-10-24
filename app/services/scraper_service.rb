class ScraperService
  require "nokogiri"
  require "open-uri"

  def initialize(url, fields)
    @url = url
    @fields = fields
  end

  def call
    scraper = Scrape.new(@url, @fields)
    scraper.scrape_data
  end
end
