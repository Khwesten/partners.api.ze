module PointOfSaleShared::PermittedParams::Create
  extend ActiveSupport::Concern

  RGEO_PERMITTED_PARAMS = [:type, coordinates: [[[]]]]
  CREATE_PERMITTED_PARAMS = [
    :trading_name, :owner_name, :document, coverage_area: RGEO_PERMITTED_PARAMS, address: RGEO_PERMITTED_PARAMS
  ]

  included do
    private

      def create_point_of_sale_params
        params.permit(CREATE_PERMITTED_PARAMS).tap do |whitelisted|
          address_coordinates = params.dig(:address, :coordinates)
          coverage_coordinates = params.dig(:coverage_area, :coordinates)

          whitelisted[:address][:coordinates] = address_coordinates if address_coordinates
          whitelisted[:coverage_area][:coordinates] = coverage_coordinates if coverage_coordinates
        end.to_h
      end
  end
end
