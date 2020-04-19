module Validators
  class AddressValidator < ActiveModel::Validator
    MUST_BE_POINT = 'must be a RGeo::Point'

    def validate(record)
      if record.address.present? && !record.address.is_a?(RGeo::Feature::Point)
        record.errors.add :address, MUST_BE_POINT
      end
    end
  end
end