module Authenticate
  class AuthenticationController < ApplicationController
    before_action :authorize

    private

    def authorize
      @payload = Token::Jwt::Decode.call(token: header)
      @current_user = User.find_by!(uuid: @payload[:user_uuid])
    rescue JWT::DecodeError => e
      render json: { error: e.message }, status: :unauthorized
    end

    def header
      request.headers['Authorization'] ? request.headers['Authorization'].split(' ').last : nil
    end
  end
end
