module Api
  module V1
    class ScrapesController < ApplicationController
      def index
        render json: { data: "Hello, World!" }
      end
    end
  end
end
