module Api
  module V1
    class ScrapesController < ApplicationController
      def index
        url = params[:url]
        fields = params[:fields] || {}

        fields = normalize_fields(fields)

        scraper_service = ScraperService.new(url, fields)
        extracted_data = scraper_service.call

        serializer = ScrapeSerializer.new(extracted_data, fields)
        render json: serializer.serialize, status: :ok
      end

      private

      def scrape_params
        params.permit(:url, fields: {})
      end

      def normalize_fields(fields)
        return fields.to_unsafe_h if fields.is_a?(ActionController::Parameters)

        fields
      end
    end
  end
end
