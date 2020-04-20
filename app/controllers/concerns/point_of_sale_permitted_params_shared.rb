module PointOfSalePermittedParamsShared
  extend ActiveSupport::Concern

  RGEO_PERMITTED_PARAMS = [:type, coordinates: []]
  CREATE_PERMITTED_PARAMS = [
    :trading_name, :owner_name, :document, coverage_area: RGEO_PERMITTED_PARAMS, address: RGEO_PERMITTED_PARAMS
  ]

  included do
    private

      def create_point_of_sale_params
        params.permit(CREATE_PERMITTED_PARAMS).tap do |whitelisted|
          if params.dig(:coverage_area, :coordinates)
            whitelisted[:coverage_area][:coordinates] = params[:coverage_area][:coordinates]
          end

          whitelisted[:address][:coordinates] = params[:address][:coordinates] if params.dig(:address, :coordinates)
        end.to_h
      end

      def search_point_of_sale_params
        params.permit(:lat, :lng).to_h
      end
  end
end