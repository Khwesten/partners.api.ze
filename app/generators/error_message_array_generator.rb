class ErrorMessageArrayGenerator
  def self.generate(error_message)
    case error_message
    when String
      [error_message]
    when Array
      error_message
    else
      raise StandardError.new "#{error_message} must be an Array or String"
    end
  end
end