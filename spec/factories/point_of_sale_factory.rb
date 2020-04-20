FactoryBot.define do
  factory :point_of_sale do
    document { Faker::Company.brazilian_company_number }
    owner_name  { Faker::Name.name }
    trading_name { Faker::Company.name }
    address {
      RGeo::GeoJSON.decode('{
        "type": "Point",
        "coordinates": [-46.57421, -21.785741]
      }')
    }
    coverage_area {
      RGeo::GeoJSON.decode('{
        "type": "MultiPolygon",
        "coordinates": [
          [[[10, 10], [45, 40], [10, 40], [10, 10]]],
          [[[15, 5], [40, 10], [10, 20], [5, 10], [15, 5]]]
        ]
      }')
    }

    trait :geo_as_hash do
      after(:build) do |point_of_sale|
        point_of_sale.coverage_area = RGeo::GeoJSON.encode(point_of_sale.coverage_area).to_h
        point_of_sale.address = RGeo::GeoJSON.encode(point_of_sale.address).to_h
      end
    end

    trait :invalid_rgeo_address do
      address { self.coverage_area }
    end

    trait :invalid_rgeo_coverage_area do
      coverage_area { self.address }
    end
  end
end
