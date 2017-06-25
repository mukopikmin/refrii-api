class JsonWebToken
  def self.payload(user)
    return nil unless user && user.id
    {
      jwt: self.encode(user_id: user.id, expires_at: 7.days.since),
      user: {
        id: user.id,
        email: user.email,
        name: user.name,
        provider: user.provider,
        expires_at: 7.days.since
      }
    }
  end

  def self.encode(payload)
    JWT.encode(payload, Rails.application.secrets.secret_key_base)
  end

  def self.decode(token)
    return HashWithIndifferentAccess.new(JWT.decode(token, Rails.application.secrets.secret_key_base)[0])
  rescue
    nil
  end
end
