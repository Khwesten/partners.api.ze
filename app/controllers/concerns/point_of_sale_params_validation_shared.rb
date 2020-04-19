module PointOfSaleParamsValidationShared
  extend ActiveSupport::Concern

  LATITUDE_CANT_BLANK_MESSAGE = "Latitude can't be blank"
  LONGITUDE_CANT_BLANK_MESSAGE = "Longitude can't be blank"

  included do
    private

      def validate_search_params
        lat_blank_error = ParamError.new(:lat, [LATITUDE_CANT_BLANK_MESSAGE]) if params[:lat].blank?
        lng_blank_error = ParamError.new(:lng, [LONGITUDE_CANT_BLANK_MESSAGE]) if params[:lng].blank?

        errors = [lat_blank_error, lng_blank_error].compact

        raise InvalidParamException.new(errors) if errors.present?
      end
  end
end