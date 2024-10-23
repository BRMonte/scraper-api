class ScrapeSerializer
  def initialize(data, fields)
    @data = data
    @fields = fields
  end

  def serialize
    @fields.transform_keys(&:to_s).each_with_object({}) do |(key, _), result|
      result[key] = @data[key] if @data.key?(key)
    end
  end
end
