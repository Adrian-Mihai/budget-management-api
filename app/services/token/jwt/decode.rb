module Token
  module Jwt
    class Decode
      class << self
        def call(token:)
          payload = JWT.decode(token, Rails.application.secrets.secret_key_base)[0]
          HashWithIndifferentAccess.new payload
        end
      end
    end
  end
end
