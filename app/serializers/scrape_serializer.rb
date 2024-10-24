class ScrapeSerializer
  def initialize(data, fields)
    @data = data
    @fields = fields
  end

  def serialize
    result = { "meta" => {} }

    @fields.transform_keys(&:to_s).each do |key, _|
      if key == "meta"
        @fields[key].each do |meta_tag|
          result["meta"][meta_tag] = @data[key] ? @data[key][meta_tag] || "" : ""
        end
      elsif @data.key?(key)
        result[key] = @data[key]
      end
    end

    result
  end
end
