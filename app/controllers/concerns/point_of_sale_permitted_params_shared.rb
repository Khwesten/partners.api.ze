module PointOfSalePermittedParamsShared
  extend ActiveSupport::Concern

  RGEO_PERMITTED_PARAMS = [:type, coordinates: []]
  CREATE_PERMITTED_PARAMS = [
    :trading_name, :owner_name, :document, coverage_area: RGEO_PERMITTED_PARAMS, address: RGEO_PERMITTED_PARAMS
  ]

  included do
    private

      def create_point_of_sale_params
        params.require(:point_of_sale).permit(CREATE_PERMITTED_PARAMS).tap do |whitelisted|
          if params.dig(:point_of_sale, :coverage_area, :coordinates)
            whitelisted[:coverage_area][:coordinates] = params[:point_of_sale][:coverage_area][:coordinates]
          end

          if params.dig(:point_of_sale, :address, :coordinates)
            whitelisted[:address][:coordinates] = params[:point_of_sale][:address][:coordinates]
          end
        end.to_h
      end

      def search_point_of_sale_params
        params.permit(:lat, :lng).to_h
      end
  end
end