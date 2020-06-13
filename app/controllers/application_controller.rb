class ApplicationController < ActionController::API
  rescue_from ActiveRecord::RecordNotFound, with: :not_found_error_message
  rescue_from ActiveRecord::RecordInvalid, with: :record_error_message
  rescue_from ActiveRecord::RecordNotDestroyed, with: :record_error_message

  private

  def not_found_error_message(error)
    logger.warn(error.message)
    render json: { error: I18n.t('errors.not_found') }, status: :not_found
  end

  def record_error_message(error)
    logger.warn(error.record.errors.messages)
    messages = error.record.errors.as_json(full_messages: true).values.flatten
    render json: { errors: messages }, status: :unprocessable_entity
  end
end
