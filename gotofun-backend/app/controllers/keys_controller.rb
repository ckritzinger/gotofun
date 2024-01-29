class KeysController < ApplicationController

  # render JWKS
  def index
    desc_params = {
      use: 'sig',
      alg: 'RS256',
      kid: key_id
    }
    jwk = JWT::JWK.new(private_key, desc_params)
    jwks = JWT::JWK::Set.new(jwk).export

    render json: jwks, status: 200
  end

  # fetch JWT for current user
  def show
    token_payload = {
      iat: Time.now.to_i,
      exp: 59.minutes.from_now.to_i,
      kid: key_id,
      aud: "https://65a8f82ce4d47fade98f24dd.powersync.journeyapps.com",
      iss: "https://gotofun-backend.fly.dev",
      sub: current_user.id,
      user_id: current_user.id,
    }

    jwt = JWT.encode(token_payload, private_key, 'RS256', { typ: 'JWT', kid: kid })
    render plain: jwt, status: 200
  end

  private

  # mock current user
  def current_user
    return OpenStruct.new(id: USER_ID)
  end

  def key_id
    Digest::SHA256.hexdigest(private_key.to_s)
  end

  def private_key
    OpenSSL::PKey::RSA.new(Rails.application.credentials.private_key)
  end
end
