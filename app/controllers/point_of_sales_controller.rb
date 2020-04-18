class PointOfSalesController < ApplicationController
  include PointOfSaleParamsValidationShared

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
    point_of_sale = PointOfSale.find(params[:id])

    render json: PointOfSaleRepresentation.build(point_of_sale)
  end

  def search
    longitude = params[:lng]
    latitude = params[:lat]

    rgeo_point = @factory.point(longitude, latitude)

    points_of_sale = PointOfSale.by_point(rgeo_point)

    render json: points_of_sale.map { |point| PointOfSaleRepresentation.build(point) }
  end
end
