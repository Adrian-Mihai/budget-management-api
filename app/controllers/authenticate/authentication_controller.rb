module Authenticate
  class AuthenticationController < ApplicationController
    before_action :authorize

    def decode
      render json: @payload.except(:exp), status: :ok
    end

    private

    def authorize
      @payload = Token::Jwt::Decode.call(token: header)
      @current_user = User.find_by!(uuid: @payload[:user_uuid])
    rescue ActiveRecord::RecordNotFound => e
      render json: { error: e.message }, status: :not_found
    rescue JWT::DecodeError => e
      render json: { error: e.message }, status: :unauthorized
    end

    def header
      request.headers['Authorization'] ? request.headers['Authorization'].split(' ').last : nil
    end
  end
end
