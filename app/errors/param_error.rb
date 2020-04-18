class ParamError
  attr_reader :param, :errors

  def initialize(param, errors)
    @param = param
    @errors = errors
  end
end