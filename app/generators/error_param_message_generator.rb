class ErrorParamMessageGenerator

  def self.generate(active_record_errors)
    errored_field_keys = active_record_errors.keys

    errored_fields_message = errored_field_keys.map do |field_key|
      field_messages = active_record_errors.full_messages_for(field_key)

      ParamError.new(field_key, field_messages)
    end

    raise InvalidParamException.new(errored_fields_message)
  end
end