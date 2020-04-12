module Token
  module Jwt
    class Encode
      class << self
        def call(user_uuid:, user_email:)
          payload = { user_uuid: user_uuid, user_email: user_email, exp: expiration }
          {
            token: JWT.encode(payload, Rails.application.credentials.secret_key_base),
            expiration: life_span.to_i
          }
        end

        private

        def life_span
          Integer(ENV.fetch('JWT_TOKEN_LIFE_TIME', '60')).minutes
        end

        def expiration
          Integer(Time.current + life_span)
        end
      end
    end
  end
end
