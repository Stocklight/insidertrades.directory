require "net/http"
require "json"
require "jwt"

class GoogleIdTokenValidator
  GOOGLE_JWKS_URI = "https://www.googleapis.com/oauth2/v3/certs"
  GOOGLE_ISSUER = "https://accounts.google.com"

  def self.validate(token:, client_id:)
    # Fetch the JWT header without verification
    header = JWT.decode(token, nil, false)[1]
    kid = header["kid"]

    # Fetch Google's public keys
    uri = URI(GOOGLE_JWKS_URI)
    response = Net::HTTP.get_response(uri)
    jwks = JSON.parse(response.body)

    # Find the key that matches our token's kid
    public_key = nil
    jwks["keys"].each do |key|
      if key["kid"] == kid
        public_key = JWT::JWK.import(key).public_key
        break
      end
    end

    raise "No matching key found" unless public_key

    # Verify the token
    decoded_token = JWT.decode(
      token,
      public_key,
      true,
      {
        algorithm: "RS256",
        verify_iss: true,
        iss: GOOGLE_ISSUER,
        verify_aud: true,
        aud: client_id,
        verify_iat: true
      }
    )

    # Return the payload
    decoded_token.first
  rescue JWT::DecodeError, OpenSSL::PKey::RSAError => e
    raise "Token validation failed: #{e.message}"
  end
end
