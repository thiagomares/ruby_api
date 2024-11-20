class AuthenticationService
  HMAC_SECRET = "1d8a8584eefa6b0a24917cac807e9d38a5db22657da34c33a7691888befac846f887137f1c494ff281c9578ff79c7366850fb975dcbd2704e78bb7de5def81f1"

  def self.encode(user_id)
    exp = 24.hours.from_now.to_i
    payload = { user_id: user_id, exp: exp }
    JWT.encode(payload, HMAC_SECRET)
  end

  def self.decode(token)
    body = JWT.decode(token, HMAC_SECRET)[0]
    HashWithIndifferentAccess.new(body)
    rescue JWT::DecodeError, JWT::ExpiredSignature, JWT::VerificationError => e
    nil
  end
end
