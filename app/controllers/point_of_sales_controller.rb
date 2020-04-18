class PointOfSalesController < ApplicationController
  before_action :validate_search_params, only: :search

  def initialize(options = {})
    @factory = options[:factory] || RGeo::Cartesian.preferred_factory()
  end

  def index
    render json: { response: "partners.ze.api" }
  end

  def create
    PointOfSale.create(partners_params)
  end

  def get
    id = params[:id]

    render json: PointOfSale.find(params[:id])
  end

  def search
    longitude = params[:lng]
    latitude = params[:lat]

    point = @factory.point(longitude, latitude)

    render json: PointOfSale.in_area(point)
  end

  private

    def partners_params
      params.require(:point_of_sale).permit(
        :trading_name, :owner_name, :document, :coverage_area, :address
      )
    end

    def validate_search_params
      invalid_params = params[:lat].blank? || params[:lng].blank?

      raise ActionController::ParameterMissing, 'lat and lng is required' if invalid_params
    end
end
