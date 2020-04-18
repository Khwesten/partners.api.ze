class ErrorFieldMessageGenerator

  def self.generate(active_record_errors)
    errored_field_keys = active_record_errors.keys

    errored_fields_message = errored_field_keys.map do |field_key|
      field_message = active_record_errors.full_messages_for(field_key)
      { param: field_key, messages: field_message }
    end

    raise InvalidFieldException.new(errored_fields_message)
  end
end