module PointOfSaleParamsValidationShared
  extend ActiveSupport::Concern

  LATITUDE_CANT_BLANK_MESSAGE = "Latitude can't be blank"
  LONGITUDE_CANT_BLANK_MESSAGE = "Longitude can't be blank"

  included do
    private

      def point_of_sale_params
        rgeo_params_permitted = [:type, coordinates: []]

        params.require(:point_of_sale).permit(
          :trading_name, :owner_name, :document, coverage_area: rgeo_params_permitted, address: rgeo_params_permitted
        ).tap do |whitelisted|
          whitelisted[:coverage_area][:coordinates] = params[:point_of_sale][:coverage_area][:coordinates]
        end
      end

      def validate_search_params
        lat_blank_error = ParamError.new(:lat, [LATITUDE_CANT_BLANK_MESSAGE]) if params[:lat].blank?
        lng_blank_error = ParamError.new(:lng, [LONGITUDE_CANT_BLANK_MESSAGE]) if params[:lng].blank?

        errors = [lat_blank_error, lng_blank_error].compact

        raise InvalidParamException.new(errors) if errors.present?
      end
  end
end