class PointOfSale < ActiveRecord::Base
  scope :in_area, -> (rgeo_point) { where("ST_CONTAINS(coverage_area, ST_GeomFromText('#{rgeo_point}'))") }
end
