require 'rails_helper'

RSpec.describe PointOfSale, type: :model do

  it 'is valid with valid attributes' do
    point_of_sale = build(:point_of_sale)

    point_of_sale.valid?

    expect(point_of_sale.valid?).to be_truthy
  end

  it 'is not valid with empty document' do
    point_of_sale = build(:point_of_sale, document: '')

    is_valid = point_of_sale.valid?

    expect(is_valid).to be_falsy
    expect(point_of_sale.errors.full_messages.first).to eq 'Document is invalid'
  end

  it 'is not valid with invalid document' do
    point_of_sale = build(:point_of_sale, document: '14321321238910001')

    is_valid = point_of_sale.valid?

    expect(is_valid).to be_falsy
    expect(point_of_sale.errors.full_messages.first).to eq 'Document is invalid'
  end

  it 'is not valid with empty owner_name' do
    point_of_sale = build(:point_of_sale, owner_name: '')

    is_valid = point_of_sale.valid?

    expect(is_valid).to be_falsy
    expect(point_of_sale.errors.full_messages.first).to eq "Owner name can't be blank"
  end

  it 'is not valid without a trading_name' do
    point_of_sale = build(:point_of_sale, trading_name: '')

    is_valid = point_of_sale.valid?

    expect(is_valid).to be_falsy
    expect(point_of_sale.errors.full_messages.first).to eq "Trading name can't be blank"
  end

  it 'is not valid with empty address' do
    point_of_sale = build(:point_of_sale, address: '')

    is_valid = point_of_sale.valid?

    expect(is_valid).to be_falsy
    expect(point_of_sale.errors.full_messages.first).to eq "Address can't be blank"
  end

  it 'is not valid without a address' do
    point_of_sale = build(:point_of_sale, address: nil)

    is_valid = point_of_sale.valid?

    expect(is_valid).to be_falsy
    expect(point_of_sale.errors.full_messages.first).to eq "Address can't be blank"
  end

  it 'is not valid with non RGeo::Point address' do
    point_of_sale = build(:point_of_sale)

    point_of_sale.address = point_of_sale.coverage_area

    is_valid = point_of_sale.valid?

    expect(is_valid).to be_falsy
    expect(point_of_sale.errors.full_messages.first).to eq 'Address must be a RGeo::Point'
  end

  it 'is not valid with empty coverage_area' do
    point_of_sale = build(:point_of_sale, coverage_area: '')

    is_valid = point_of_sale.valid?

    expect(is_valid).to be_falsy
    expect(point_of_sale.errors.full_messages.first).to eq "Coverage area can't be blank"
  end

  it 'is not valid without a coverage_area' do
    point_of_sale = build(:point_of_sale, coverage_area: nil)

    is_valid = point_of_sale.valid?

    expect(is_valid).to be_falsy
    expect(point_of_sale.errors.full_messages.first).to eq "Coverage area can't be blank"
  end

  it 'is not valid with non RGeo::MultiPolygon coverage_area' do
    point_of_sale = build(:point_of_sale)

    point_of_sale.coverage_area = point_of_sale.address

    is_valid = point_of_sale.valid?

    expect(is_valid).to be_falsy
    expect(point_of_sale.errors.full_messages.first).to eq 'Coverage area must be a RGeo::MultiPolygon'
  end

  context 'with register on database' do
    let!(:point_of_sale) { create(:point_of_sale) }

    it 'is not valid using the same document' do
      same_point_of_sale_without_id = point_of_sale.dup

      is_valid = same_point_of_sale_without_id.valid?

      expect(is_valid).to be_falsy
      expect(same_point_of_sale_without_id.errors.full_messages.first).to eq 'Document has already been taken'
    end

    it 'return an array with one point_of_sale when point is within a coverage area' do
      factory = RGeo::Cartesian.preferred_factory()

      result = PointOfSale.by_rgeo_point(factory.point(11, 11))

      expect(result.one?)
      expect(result.first.id).to eq point_of_sale.id
    end

    it 'return an empty array with point is out a coverage area' do
      factory = RGeo::Cartesian.preferred_factory()

      result = PointOfSale.by_rgeo_point(factory.point(0, 0))

      expect(result.empty?)
    end
  end
end
