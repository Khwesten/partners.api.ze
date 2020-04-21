require 'rails_helper'

RSpec.describe PointOfSale, type: :model do

  context '.valid?' do
    RSpec.shared_examples 'invalid with message' do |message|
      it do
        is_valid = point_of_sale.valid?

        expect(is_valid).to be_falsy
        expect(point_of_sale.errors.full_messages.first).to eq message
      end
    end

    it 'is valid with valid attributes' do
      point_of_sale = build(:point_of_sale)

      point_of_sale.valid?

      expect(point_of_sale.valid?).to be_truthy
    end

    context 'with empty document' do
      it_should_behave_like 'invalid with message', 'Document is invalid' do
        let(:point_of_sale) { build(:point_of_sale, document: '') }
      end
    end

    context 'with invalid document' do
      it_should_behave_like 'invalid with message', 'Document is invalid' do
        let(:point_of_sale) { build(:point_of_sale, document: '14321321238910001') }
      end
    end

    context 'with empty owner_name' do
      it_should_behave_like 'invalid with message', "Owner name can't be blank" do
        let(:point_of_sale) { build(:point_of_sale, owner_name: '') }
      end
    end

    context 'with empty trading_name' do
      it_should_behave_like 'invalid with message', "Trading name can't be blank" do
        let(:point_of_sale) { build(:point_of_sale, trading_name: '') }
      end
    end

    context 'with empty address' do
      it_should_behave_like 'invalid with message', "Address can't be blank" do
        let(:point_of_sale) { build(:point_of_sale, address: '') }
      end
    end

    context 'with nil address' do
      it_should_behave_like 'invalid with message', "Address can't be blank" do
        let(:point_of_sale) { build(:point_of_sale, address: nil) }
      end
    end

    context 'with non RGeo::Point address' do
      it_should_behave_like 'invalid with message', 'Address must be a RGeo::Point' do
        let(:point_of_sale) { build(:point_of_sale, :invalid_rgeo_address) }
      end
    end

    context 'with empty coverage_area' do
      it_should_behave_like 'invalid with message', "Coverage area can't be blank" do
        let(:point_of_sale) { build(:point_of_sale,  coverage_area: '') }
      end
    end

    context 'with nil coverage_area' do
      it_should_behave_like 'invalid with message', "Coverage area can't be blank" do
        let(:point_of_sale) { build(:point_of_sale,  coverage_area: nil) }
      end
    end

    context 'with non RGeo::MultiPolygon coverage_area' do
      it_should_behave_like 'invalid with message', 'Coverage area must be a RGeo::MultiPolygon' do
        let(:point_of_sale) { build(:point_of_sale, :invalid_rgeo_coverage_area) }
      end
    end

    context 'with document already registered on database' do
      it_should_behave_like 'invalid with message', 'Document has already been taken' do
        let(:persisted_point_of_sale) { create(:point_of_sale) }
        let(:point_of_sale) { persisted_point_of_sale.dup }
      end
    end
  end

  context '#by_rgeo_point' do
    context 'with register on database' do
      let!(:point_of_sale) { create(:point_of_sale) }

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
end
