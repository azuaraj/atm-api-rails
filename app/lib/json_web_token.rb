require "jwt"

class JsonWebToken
  SECRET_KEY = Rails.application.credentials.secret_key_base.to_s

  def self.encode(payload, exp = 24.hours.from_now)
    payload[:exp] = exp.to_i
    payload[:jti] = SecureRandom.uuid
    JWT.encode(payload, SECRET_KEY)
  end

  def self.decode(token)
    body = JWT.decode(token, SECRET_KEY)[0]
    payload = HashWithIndifferentAccess.new(body)

    return nil if RevokedToken.exists?(jti: payload[:jti])

    payload
  rescue JWT::ExpiredSignature
    nil
  rescue JWT::DecodeError
    nil
  end
end
