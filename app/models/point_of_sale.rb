class PointOfSale < ActiveRecord::Base
  validates :trading_name, :owner_name, :document, :coverage_area, :address, presence: true

  scope :by_rgeo_point, -> (rgeo_point) { where("ST_CONTAINS(coverage_area, ST_GeomFromText('#{rgeo_point}'))") }
end
