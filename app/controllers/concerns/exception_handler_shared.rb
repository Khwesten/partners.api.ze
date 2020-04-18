module ExceptionHandlerShared
  extend ActiveSupport::Concern

  included do
    rescue_from ActionController::ParameterMissing, with: :required_params_exception_handler

    protected

      def required_params_exception_handler(exception)
        render json: { message: exception.message }.to_json, status: 400
      end
  end
end

