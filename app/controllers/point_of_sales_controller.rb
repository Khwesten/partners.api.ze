class PointOfSalesController < ApplicationController
  include PointOfSaleShared::PermittedParams
  include PointOfSaleShared::ParamsValidation

  before_action :validate_search_params, only: :search
  before_action :validate_create_params, only: :create

  def initialize(options = {})
    @rgeo_cartesian_factory = options[:factory] || RGeo::Cartesian.preferred_factory()
  end

  def index
    render json: { response: 'partners.ze.api' }
  end

  def create
    point_of_sale = PointOfSaleParser.from_params(create_point_of_sale_params)

    if point_of_sale.invalid?
      errors = ErrorFieldMessageGenerator.generate(point_of_sale.errors)
      raise InvalidParamError.new(errors)
    end

    point_of_sale.save

    render json: PointOfSale::Representations::Default.build(point_of_sale)
  end

  def get
    point_of_sale = PointOfSale.find(params[:id])

    render json: PointOfSale::Representations::Default.build(point_of_sale)
  end

  def search
    longitude = search_point_of_sale_params[:lng]
    latitude = search_point_of_sale_params[:lat]

    rgeo_point = @rgeo_cartesian_factory.point(longitude, latitude)

    points_of_sale = PointOfSale.by_rgeo_point(rgeo_point)

    render json: points_of_sale.map { |point_of_sale| PointOfSale::Representations::Default.build(point_of_sale) }
  end
end
