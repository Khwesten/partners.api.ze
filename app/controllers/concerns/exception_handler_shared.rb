module ExceptionHandlerShared
  extend ActiveSupport::Concern

  included do
    rescue_from ActiveRecord::RecordNotFound, with: :record_not_found_exception_handler
    rescue_from ActionController::ParameterMissing, with: :required_params_exception_handler

    protected

      def required_params_exception_handler(exception)
        render json: { message: exception.message }, status: 400
      end

      def record_not_found_exception_handler
        render json: { message: "resource does not exists" }, status: 404
      end
  end
end

