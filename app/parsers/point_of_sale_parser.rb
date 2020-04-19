class PointOfSaleParser
  def self.from_params(params, decoder: RGeo::GeoJSON)
    coverage_area = params[:coverage_area]
    address = params[:address]

    # TODO: Make validation to check decode successfully
    rgeo_coverage_area = decoder.decode(coverage_area)
    rgeo_address = decoder.decode(address)

    PointOfSale.new(
      trading_name: params[:trading_name],
      owner_name: params[:owner_name],
      document: params[:document],
      coverage_area: rgeo_coverage_area,
      address: rgeo_address
    )
  end
end