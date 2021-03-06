module ExceptionHandlerShared
  extend ActiveSupport::Concern

  RESOURCE_DOES_NOT_EXIST = 'resource does not exists'

  included do
    rescue_from InvalidParamError, with: :invalid_param_exception_handler
    rescue_from ActiveRecord::RecordNotFound, with: :record_not_found_exception_handler

    protected

      def record_not_found_exception_handler
        render json: { errors: RESOURCE_DOES_NOT_EXIST }, status: 404
      end

      def invalid_param_exception_handler(exception)
        render json: { errors: exception.errors }, status: 400
      end
  end
end

