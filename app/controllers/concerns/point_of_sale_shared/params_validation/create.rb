module PointOfSaleShared::ParamsValidation::Create
  extend ActiveSupport::Concern

  include PermittedParamsBase

  MUST_BE_A_VALID_GEOJSON = 'must be a valid GeoJSON({"type": ..., "coordinates": ...})'

  included do
    private

      def validate_create_params
        validate_create_blank_params(create_point_of_sale_params)
        validate_create_rgeo_format_params(create_point_of_sale_params)
      end

      def validate_create_blank_params(params)
        create_permitted_params =
          PermittedParamsBase.permitted_params_keys(PointOfSaleShared::PermittedParams::Create::CREATE_PERMITTED_PARAMS)

        errors = create_permitted_params.map do |key|
          value = params[key]

          if value.blank?
            ParamError.new(key, "#{key.to_s.humanize} #{PointOfSaleShared::ParamsValidation::CANT_BE_BLANK}")
          end
        end.compact

        raise InvalidParamException.new(errors) if errors.present?
      end

      def validate_create_rgeo_format_params(params, decoder: RGeo::GeoJSON)
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

        raise InvalidParamException.new(errors) if errors.present?
      end
  end
end
