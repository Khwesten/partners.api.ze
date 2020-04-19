class PointOfSale < ActiveRecord::Base
  include ActiveModel::Validations

  validates_cnpj :document
  validates :document, uniqueness: true
  validates_with Validators::CoverageAreaValidator, Validators::AddressValidator
  validates :trading_name, :owner_name, :document, :coverage_area, :address, presence: true

  scope :by_rgeo_point, -> (rgeo_point) { where("ST_CONTAINS(coverage_area, ST_GeomFromText('#{rgeo_point}'))") }
end
