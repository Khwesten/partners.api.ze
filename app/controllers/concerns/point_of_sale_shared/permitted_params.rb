module PointOfSaleShared::PermittedParams
  extend ActiveSupport::Concern

  include PointOfSaleShared::PermittedParams::Search
  include PointOfSaleShared::PermittedParams::Create
end
