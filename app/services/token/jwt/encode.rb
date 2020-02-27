module Token
  module Jwt
    class Encode
      class << self
        def call(user_uuid:, user_email:)
          payload = { user_uuid: user_uuid, user_email: user_email, exp: expiration.to_i }
          JWT.encode(payload, Rails.application.secrets.secret_key_base)
        end

        private

        def expiration
          (ENV['JWT_TOKEN_LIFE_TIME'] || 60).to_i.minutes.from_now
        end
      end
    end
  end
end
