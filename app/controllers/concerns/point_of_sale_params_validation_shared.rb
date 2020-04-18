module PointOfSaleParamsValidationShared
  extend ActiveSupport::Concern

  included do
    private

      def point_of_sale_params
        params.require(:point_of_sale).permit(
          :trading_name, :owner_name, :document, :coverage_area, :address
        )
      end

      def validate_search_params
        lat_blank_error = ParamError.new(:lat, ["Latitude can't be blank"]) if params[:lat].blank?
        lng_blank_error = ParamError.new(:lng, ["Longitude can't be blank"]) if params[:lng].blank?

        errors = [lat_blank_error, lng_blank_error].compact

        raise InvalidParamException.new(errors) if errors.present?
      end
  end
end