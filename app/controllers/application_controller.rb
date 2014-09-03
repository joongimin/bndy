class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def respond_with_error(error_message = nil, args = {})
    error_message = 'Not authorized' if error_message.nil?

    if error_message.kind_of?(ActiveRecord::Base)
      if request.xhr?
        render js: "alert('#{error_message.errors.messages.values.flatten.first}')", status: :ok
      else
        render nothing: true, status: :bad_request
      end
    else
      if request.xhr?
        render js: "alert('#{error_message}')", status: :ok
      else
        render nothing: true, status: :bad_request
      end
    end
  end
end
