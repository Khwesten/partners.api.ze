module Validators
  class CoverageAreaValidator < ActiveModel::Validator
    MUST_BE_MULTIPOLYGON = 'must be a RGeo::MultiPolygon'

    def validate(record)
      if record.coverage_area.present? && !record.coverage_area.is_a?(RGeo::Feature::MultiPolygon)
        record.errors.add :coverage_area, MUST_BE_MULTIPOLYGON
      end
    end
  end
end