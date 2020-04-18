class PointOfSaleRepresentation

  def self.build(point_of_sale, encoder: RGeo::GeoJSON)
    {
      id: point_of_sale.id,
      trading_name: point_of_sale.trading_name,
      owner_name: point_of_sale.owner_name,
      document: point_of_sale.document,
      coverage_area: encoder.encode(point_of_sale.coverage_area),
      address: encoder.encode(point_of_sale.address)
    }
  end
end