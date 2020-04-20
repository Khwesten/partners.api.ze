require 'rails_helper'

RSpec.describe 'PointOfSales', type: :request do
  describe '.get' do
    context 'when receive a valid id' do
      it 'exist on database' do
        document = Faker::Company.brazilian_company_number
        point_of_sale = create(:point_of_sale, document: document)

        get "/pos/#{point_of_sale.id}"

        response_body = JSON.parse(response.body)

        expect(response).to be_successful
        expect(response_body['document']).to eq(point_of_sale.document)
        expect(response_body['owner_name']).to eq(point_of_sale.owner_name)
        expect(response_body['trading_name']).to eq(point_of_sale.trading_name)
        expect(RGeo::GeoJSON.decode(response_body['address'])).to eq(point_of_sale.address)
        expect(RGeo::GeoJSON.decode(response_body['coverage_area'])).to eq(point_of_sale.coverage_area)
      end

      it 'no exist on database' do
        get '/pos/0'

        expect(response).to be_not_found
      end
    end

    context 'when receive a invalid id' do
      it do
        get '/pos/abc123'

        expect(response).to be_not_found
      end
    end
  end

  describe '.search' do
    context 'when receive valid lat and lng' do
      it 'exist on database' do
        point_of_sale = create(:point_of_sale)

        get '/pos?lat=11&lng=11'

        response_body = JSON.parse(response.body).first

        expect(response).to be_successful
        expect(response_body['document']).to eq(point_of_sale.document)
        expect(response_body['owner_name']).to eq(point_of_sale.owner_name)
        expect(response_body['trading_name']).to eq(point_of_sale.trading_name)
        expect(RGeo::GeoJSON.decode(response_body['address'])).to eq(point_of_sale.address)
        expect(RGeo::GeoJSON.decode(response_body['coverage_area'])).to eq(point_of_sale.coverage_area)
      end

      it 'no exist on database' do
        get '/pos?lat=0&lng=0'

        response_body = JSON.parse(response.body)

        expect(response_body.empty?)
        expect(response).to be_successful
      end
    end

    context 'when receive invalid param' do
      it 'lat without lng' do
        get '/pos?lat=abc'

        expect(response).to be_bad_request
      end

      it 'lng without lat' do
        get '/pos?lng=abc'

        expect(response).to be_bad_request
      end

      it 'lat and lng' do
        get '/pos?lat=abc&lng=abc'

        response_body = JSON.parse(response.body)

        expect(response_body.empty?)
        expect(response).to be_successful
      end
    end

    context 'when not receive some param' do
      it 'lat' do
        get '/pos?lat=10'

        expect(response).to be_bad_request
      end

      it 'lng' do
        get '/pos?lng=10'

        expect(response).to be_bad_request
      end
    end

    context 'when not receive params' do
      it 'without' do
        get '/pos'

        expect(response).to be_bad_request
      end
    end
  end
end