class PointOfSale < ActiveRecord::Base
  scope :by_point, -> (rgeo_point) { where("ST_CONTAINS(coverage_area, ST_GeomFromText('#{rgeo_point}'))") }
end
