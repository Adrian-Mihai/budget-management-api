module Authenticate
  class UsersController < AuthenticationController
    def decode
      user_info = @payload.except(:exp)
      user_info.merge!(username: @current_user.username)
      render json: user_info, status: :ok
    end
  end
end
