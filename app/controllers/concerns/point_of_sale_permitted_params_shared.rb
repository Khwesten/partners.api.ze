module PointOfSalePermittedParamsShared
  extend ActiveSupport::Concern

  included do
    private

      def create_point_of_sale_params
        rgeo_params_permitted = [:type, coordinates: []]

        params.require(:point_of_sale).permit(
          :trading_name, :owner_name, :document, coverage_area: rgeo_params_permitted, address: rgeo_params_permitted
        ).tap do |whitelisted|
          whitelisted[:coverage_area][:coordinates] = params[:point_of_sale][:coverage_area][:coordinates]
        end
      end
  end
end