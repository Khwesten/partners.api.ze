module PermittedParamsBase
  extend ActiveSupport::Concern

  def self.permitted_params_keys(permitted_params)
    permitted_params.flatten.map do |value|
      case value
      when Symbol, String
        value
      when Hash
        value.keys.flatten
      end
    end.flatten
  end
end