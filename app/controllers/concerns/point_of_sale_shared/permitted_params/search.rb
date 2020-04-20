module PointOfSaleShared::PermittedParams::Search
  extend ActiveSupport::Concern

  included do
    private

      def search_point_of_sale_params
        params.permit(:lat, :lng).to_h
      end
  end
end
