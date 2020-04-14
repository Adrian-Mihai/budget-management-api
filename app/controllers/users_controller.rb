class UsersController < ApplicationController
  def create
    result = Users::Create.new(parameters: user_params.merge(uuid: SecureRandom.uuid)).call
    return render json: { errors: result.errors }, status: :unprocessable_entity unless result.valid?

    response = Token::Jwt::Encode.call(user_uuid: result.user.uuid, user_email: result.user.email)
    render json: response, status: :created
  end

  def authenticate
    @user = User.find_by!(email: user_params[:email])

    unless @user.authenticate(user_params[:password])
      response = { error: I18n.t('errors.unauthenticated') }
      return render json: response, status: :unauthorized
    end

    response = Token::Jwt::Encode.call(user_uuid: @user.uuid, user_email: @user.email)
    render json: response, status: :created
  rescue ActiveRecord::RecordNotFound
    render json: { error: I18n.t('errors.unauthenticated') }, status: :unauthorized
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end
end
