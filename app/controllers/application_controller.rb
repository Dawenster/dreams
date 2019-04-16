class ApplicationController < ActionController::Base
  def log_and_return_error(e)
    unless Rails.env.test?
      puts '*' * 20
      puts "Error: #{e.message}"
      puts "backtrace: #{e.backtrace}" if e.backtrace.present?
      puts '*' * 20
    end

    error_name = e.class.name
    status = ActionDispatch::ExceptionWrapper.status_code_for_exception(
      error_name
    )

    render json: {
      error: error_name
    }, status: status
  end
end
