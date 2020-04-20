module PointOfSaleShared::ParamsValidation::Search
  extend ActiveSupport::Concern

  LATITUDE_CANT_BLANK_MESSAGE = "Latitude #{PointOfSaleShared::ParamsValidation::CANT_BE_BLANK}"
  LONGITUDE_CANT_BLANK_MESSAGE = "Longitude #{PointOfSaleShared::ParamsValidation::CANT_BE_BLANK}"

  included do
    private

      def validate_search_params
        lat_blank_error = if search_point_of_sale_params[:lat].blank?
          ParamError.new(:lat, LATITUDE_CANT_BLANK_MESSAGE)
        end

        lng_blank_error = if search_point_of_sale_params[:lng].blank?
          ParamError.new(:lng, LONGITUDE_CANT_BLANK_MESSAGE)
        end

        errors = [lat_blank_error, lng_blank_error].compact

        raise InvalidParamError.new(errors) if errors.present?
      end
  end
end
