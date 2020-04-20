module PointOfSaleParamsValidationShared
  extend ActiveSupport::Concern
  include PermittedParamsBase

  CANT_BE_BLANK = "can't be blank"
  LATITUDE_CANT_BLANK_MESSAGE = "Latitude #{CANT_BE_BLANK}"
  LONGITUDE_CANT_BLANK_MESSAGE = "Longitude #{CANT_BE_BLANK}"
  MUST_BE_A_VALID_GEOJSON = 'must be a valid GeoJSON({"type": ..., "coordinates": ...})'

  included do
    private

      def validate_search_params
        lat_blank_error = if search_point_of_sale_params[:lat].blank?
          ParamError.new(:lat, LATITUDE_CANT_BLANK_MESSAGE)
        end

        lng_blank_error = if search_point_of_sale_params[:lng].blank?
          ParamError.new(:lng, LONGITUDE_CANT_BLANK_MESSAGE)
        end

        errors = [lat_blank_error, lng_blank_error].compact

        raise InvalidParamError.new(errors) if errors.present?
      end

      def validate_create_params
        validate_blank_params(create_point_of_sale_params)
        validate_rgeo_format_params(create_point_of_sale_params)
      end

      def validate_blank_params(params)
        create_permitted_params =
          PermittedParamsBase.permitted_params_keys(PointOfSalePermittedParamsShared::CREATE_PERMITTED_PARAMS)

        errors = create_permitted_params.map do |key|
          value = params[key]

          ParamError.new(key, "#{key.to_s.humanize} #{CANT_BE_BLANK}") if value.blank?
        end.compact

        raise InvalidParamError.new(errors) if errors.present?
      end

      def validate_rgeo_format_params(params, decoder: RGeo::GeoJSON)
        rgeo_params = {
          address: params[:address],
          coverage_area: params[:coverage_area]
        }

        errors = rgeo_params.map do |key, value|
          unless decoder.decode(value)
            error_message = "#{key.to_s.humanize} #{MUST_BE_A_VALID_GEOJSON}"

            ParamError.new(key, error_message)
          end
        end.compact

        raise InvalidParamError.new(errors) if errors.present?
      end
  end
end
