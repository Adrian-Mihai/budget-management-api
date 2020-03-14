module Authenticate
  class UsersController < AuthenticationController
    def decode
      render json: @payload.except(:exp), status: :ok
    end
  end
end
