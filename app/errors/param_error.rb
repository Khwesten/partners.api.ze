class ParamError
  attr_reader :param, :errors

  def initialize(param, errors, error_message_generator: ErrorMessageArrayGenerator)
    @param = param
    @errors = error_message_generator.generate(errors)
  end
end