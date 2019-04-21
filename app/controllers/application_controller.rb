class MissingParameterError < StandardError
  def initialize(missing_params)
    @missing_params = missing_params
  end

  def code
    400
  end

  def message
    "Need to pass in #{@missing_params.to_sentence} as #{'parameter'
      .pluralize(@missing_params.count)}"
  end
end

class ApplicationController < ActionController::Base
  def log_and_return_error(e)
    unless Rails.env.test?
      puts '*' * 20
      puts "Error: #{e.message}"
      puts "backtrace: #{e.backtrace}" if e.backtrace.present?
      puts '*' * 20
    end

    custom_errors = [MissingParameterError, InvalidAmountError]
    error_message = custom_errors.include?(e.class) ? e.message : e.class.name

    status = e.try(:code) ||
               ActionDispatch::ExceptionWrapper.status_code_for_exception(
                 e.class.name
               )

    render json: {
      error: error_message
    }, status: status
  end

  def required_parameters(required_param_names=[])
    missing_params = missing_parameters(required_param_names)

    if missing_params.any?
      raise MissingParameterError.new(missing_params)
    end
  end

  def missing_parameters(required_param_names)
    missing = []

    required_param_names.each do |required_param_name|
      param = params[required_param_name]

      # Required because false.blank? == true
      next if [false].include?(param)

      missing << required_param_name if param.blank?
    end

    missing
  end
end
