class ApplicationController < ActionController::API
  def home
    render json: { welcome: I18n.t('hello') }, status: :ok
  end

  def authenticate
    @user = User.find_by!(email: user_params[:email])

    unless @user.authenticate(user_params[:password])
      response = { error: I18n.t('errors.unauthenticated') }
      return render json: response, status: :unauthorized
    end

    token = Token::Jwt::Encode.call(user_uuid: @user.uuid, user_email: @user.email)
    render json: { token: token }, status: :created
  rescue ActiveRecord::RecordNotFound => e
    render json: { error: e.message }, status: :not_found
  end

  private

  def user_params
    params.require(:application).permit(:email, :password)
  end
end
