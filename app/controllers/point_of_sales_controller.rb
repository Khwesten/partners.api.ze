class PointOfSalesController < ApplicationController
  include PointOfSaleParamsValidationShared

  before_action :validate_search_params, only: :search

  def initialize(options = {})
    @rgeo_cartesian_factory = options[:factory] || RGeo::Cartesian.preferred_factory()
  end

  def index
    render json: { response: "partners.ze.api" }
  end

  def create
    point_of_sale = PointOfSale.new(point_of_sale_params)

    result = if point_of_sale.valid?
      point_of_sale.save
    else
      ErrorParamMessageGenerator.generate(point_of_sale.errors)
    end

    render json: result
  end

  def get
    point_of_sale = PointOfSale.find(params[:id])

    render json: PointOfSaleRepresentation.build(point_of_sale)
  end

  def search
    longitude = params[:lng]
    latitude = params[:lat]

    rgeo_point = @rgeo_cartesian_factory.point(longitude, latitude)

    points_of_sale = PointOfSale.by_rgeo_point(rgeo_point)

    render json: points_of_sale.map { |point_of_sale| PointOfSaleRepresentation.build(point_of_sale) }
  end
end
