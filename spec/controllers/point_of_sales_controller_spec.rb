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

  describe '.create' do
    CONTENT_TYPE_JSON_HEADER = { 'CONTENT_TYPE': 'application/json' }

    context 'when receive valid params' do
      it do
        point_of_sale = build(:point_of_sale, :geo_as_hash)

        post '/pos', params: point_of_sale.to_json, headers: CONTENT_TYPE_JSON_HEADER

        response_body = JSON.parse(response.body)

        expect(response).to be_successful
        expect(response_body['document']).to eq(point_of_sale.document)
        expect(response_body['owner_name']).to eq(point_of_sale.owner_name)
        expect(response_body['trading_name']).to eq(point_of_sale.trading_name)
        expect(response_body['address']).to eq(point_of_sale.address.stringify_keys)
        expect(response_body['coverage_area']).to eq(point_of_sale.coverage_area.stringify_keys)
      end
    end

    context 'when receive' do
      RSpec.shared_examples 'all params is missing' do |params|
        it do
          post '/pos', params: params, headers: CONTENT_TYPE_JSON_HEADER

          response_body = JSON.parse(response.body)
          document_error = response_body['errors'].select  { |error| error['param'] == 'document' }.first
          address_area_error = response_body['errors'].select  { |error| error['param'] == 'address' }.first
          owner_name_error = response_body['errors'].select  { |error| error['param'] == 'owner_name' }.first
          trading_name_error = response_body['errors'].select  { |error| error['param'] == 'trading_name' }.first
          coverage_area_error = response_body['errors'].select  { |error| error['param'] == 'coverage_area' }.first

          expect(response).to be_bad_request
          expect(response_body['errors'].size).to eq 5
          expect(document_error['param']).to eq 'document'
          expect(document_error['errors']).to eq "Document can't be blank"
          expect(address_area_error['param']).to eq 'address'
          expect(address_area_error['errors']).to eq "Address can't be blank"
          expect(owner_name_error['param']).to eq 'owner_name'
          expect(owner_name_error['errors']).to eq "Owner name can't be blank"
          expect(trading_name_error['param']).to eq 'trading_name'
          expect(trading_name_error['errors']).to eq "Trading name can't be blank"
          expect(coverage_area_error['param']).to eq 'coverage_area'
          expect(coverage_area_error['errors']).to eq "Coverage area can't be blank"
        end
      end

      context 'empty' do
        context 'document param' do
          it do
            point_of_sale = build(:point_of_sale, :geo_as_hash, document: '')

            post '/pos', params: point_of_sale.to_json, headers: CONTENT_TYPE_JSON_HEADER

            response_body = JSON.parse(response.body)

            expect(response).to be_bad_request
            expect(response_body['errors'].first['param']).to eq 'document'
            expect(response_body['errors'].first['errors']).to eq "Document can't be blank"
          end
        end

        context 'trading_name param' do
          it do
            point_of_sale = build(:point_of_sale, :geo_as_hash, trading_name: '')

            post '/pos', params: point_of_sale.to_json, headers: CONTENT_TYPE_JSON_HEADER

            response_body = JSON.parse(response.body)

            expect(response).to be_bad_request
            expect(response_body['errors'].first['param']).to eq 'trading_name'
            expect(response_body['errors'].first['errors']).to eq "Trading name can't be blank"
          end
        end

        context 'owner_name param' do
          it do
            point_of_sale = build(:point_of_sale, :geo_as_hash, owner_name: '')

            post '/pos', params: point_of_sale.to_json, headers: CONTENT_TYPE_JSON_HEADER

            response_body = JSON.parse(response.body)

            expect(response).to be_bad_request
            expect(response_body['errors'].first['param']).to eq 'owner_name'
            expect(response_body['errors'].first['errors']).to eq "Owner name can't be blank"
          end
        end

        context 'address param' do
          it do
            point_of_sale = build(:point_of_sale, :geo_as_hash, address: '')

            post '/pos', params: point_of_sale.to_json, headers: CONTENT_TYPE_JSON_HEADER

            response_body = JSON.parse(response.body)

            expect(response).to be_bad_request
            expect(response_body['errors'].first['param']).to eq 'address'
            expect(response_body['errors'].first['errors']).to eq "Address can't be blank"
          end
        end

        context 'coverage_area param' do
          it do
            point_of_sale = build(:point_of_sale, :geo_as_hash, coverage_area: '')

            post '/pos', params: point_of_sale.to_json, headers: CONTENT_TYPE_JSON_HEADER

            response_body = JSON.parse(response.body)

            expect(response).to be_bad_request
            expect(response_body['errors'].first['param']).to eq 'coverage_area'
            expect(response_body['errors'].first['errors']).to eq "Coverage area can't be blank"
          end
        end

        context 'coverage_area and address params' do
          it do
            point_of_sale = build(:point_of_sale, :geo_as_hash, coverage_area: '', address: '')

            post '/pos', params: point_of_sale.to_json, headers: CONTENT_TYPE_JSON_HEADER

            response_body = JSON.parse(response.body)
            address_area_error = response_body['errors'].select  { |error| error['param'] == 'address' }.first
            coverage_area_error = response_body['errors'].select  { |error| error['param'] == 'coverage_area' }.first

            expect(response).to be_bad_request
            expect(response_body['errors'].size).to eq 2
            expect(coverage_area_error['param']).to eq 'coverage_area'
            expect(coverage_area_error['errors']).to eq "Coverage area can't be blank"
            expect(address_area_error['param']).to eq 'address'
            expect(address_area_error['errors']).to eq "Address can't be blank"
          end
        end

        context 'body' do
          include_examples 'all params is missing', nil
        end
      end

      context "params don't match with point_of_sale params" do
        params = { dont_match_param: 'dont_match_value' }.to_json

        include_examples 'all params is missing', params
      end
    end

    context 'when receive a invalid' do
      context 'document param' do
        it do
          point_of_sale = build(:point_of_sale, :geo_as_hash, document: '1234567890')

          post '/pos', params: point_of_sale.to_json, headers: CONTENT_TYPE_JSON_HEADER

          response_body = JSON.parse(response.body)

          expect(response).to be_bad_request
          expect(response_body['errors'].first['param']).to eq 'document'
          expect(response_body['errors'].first['errors']).to eq ['Document is invalid']
        end
      end

      context 'address param' do
        it do
          point_of_sale = build(:point_of_sale, :geo_as_hash)
          point_of_sale.address = point_of_sale.coverage_area

          post '/pos', params: point_of_sale.to_json, headers: CONTENT_TYPE_JSON_HEADER

          response_body = JSON.parse(response.body)

          expect(response).to be_bad_request
          expect(response_body['errors'].first['param']).to eq 'address'
          expect(response_body['errors'].first['errors']).to eq ['Address must be a RGeo::Point']
        end
      end

      context 'coverage_area param' do
        it do
          point_of_sale = build(:point_of_sale, :geo_as_hash)
          point_of_sale.coverage_area = point_of_sale.address

          post '/pos', params: point_of_sale.to_json, headers: CONTENT_TYPE_JSON_HEADER

          response_body = JSON.parse(response.body)

          expect(response).to be_bad_request
          expect(response_body['errors'].first['param']).to eq 'coverage_area'
          expect(response_body['errors'].first['errors']).to eq ['Coverage area must be a RGeo::MultiPolygon']
        end
      end
    end
  end
end
