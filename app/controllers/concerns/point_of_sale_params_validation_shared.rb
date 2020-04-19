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
          ParamError.new(:lat, [LATITUDE_CANT_BLANK_MESSAGE])
        end

        lng_blank_error = if search_point_of_sale_params[:lng].blank?
          ParamError.new(:lng, [LONGITUDE_CANT_BLANK_MESSAGE])
        end

        errors = [lat_blank_error, lng_blank_error].compact

        raise InvalidParamException.new(errors) if errors.present?
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

        raise InvalidParamException.new(errors) if errors.present?
      end

      def validate_rgeo_format_params(params, decoder: RGeo::GeoJSON)
        address = params[:address]
        coverage_area = params[:coverage_area]

        coverage_area_error = unless decoder.decode(coverage_area)
          ParamError.new(:coverage_area, "#{:coverage_area.to_s.humanize} #{MUST_BE_A_VALID_GEOJSON}")
        end

        address_error = unless decoder.decode(address)
          ParamError.new(:coverage_area, "#{:coverage_area.to_s.humanize} #{MUST_BE_A_VALID_GEOJSON}")
        end

        errors = [address_error, coverage_area_error].compact

        raise InvalidParamException.new(errors) if errors.present?
      end
  end
end