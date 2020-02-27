class UsersController < ApplicationController
  def create
    @user = User.new(user_params.merge(uuid: SecureRandom.uuid))
    render status: :created if @user.save!
  rescue ActiveRecord::RecordInvalid => e
    message = e.record.errors.as_json(full_messages: true).values.join('. ')
    render json: { errors: message }, status: :unprocessable_entity
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end
end
