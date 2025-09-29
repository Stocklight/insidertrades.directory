class GoogleSignin
  attr_reader :email, :first_name, :last_name, :photo_url, :user_id

  # Your provided client ID
  WEB_CLIENT_ID = "98725179367-0nt90fh00mfb6vmpm3as1hb8453r0ki0.apps.googleusercontent.com"

  def initialize(web_credential:)
    @web_credential = web_credential
    @client_id = WEB_CLIENT_ID
  end
  
  def valid?
    return false if @web_credential.blank?

    validated_token = GoogleIdTokenValidator.validate(
      token: @web_credential,
      client_id: @client_id,
    ).stringify_keys

    @email = validated_token['email']
    @first_name = validated_token['given_name']
    @last_name = validated_token['family_name']
    @photo_url = validated_token['picture']
    @user_id = validated_token['sub']
    
    @email.present?
  rescue => e
    Rails.logger.error "Google signin validation failed: #{e.message}"
    false
  end
end