module PointOfSaleShared::ParamsValidation
  extend ActiveSupport::Concern

  CANT_BE_BLANK = "can't be blank"

  include PointOfSaleShared::ParamsValidation::Search
  include PointOfSaleShared::ParamsValidation::Create
end
