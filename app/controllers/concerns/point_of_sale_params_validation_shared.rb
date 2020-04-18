module PointOfSaleParamsValidationShared
  extend ActiveSupport::Concern

  VALIDATION_SEARCH_ERROR = 'lat and lng is required'

  included do
    private

      def point_of_sales_params
        params.require(:point_of_sale).permit(
          :trading_name, :owner_name, :document, :coverage_area, :address
        )
      end

      def validate_search_params
        invalid_params = params[:lat].blank? || params[:lng].blank?

        raise ActionController::ParameterMissing, VALIDATION_SEARCH_ERROR if invalid_params
      end
  end
end