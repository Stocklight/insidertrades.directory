class UsersMailer < ApplicationMailer
  def verification_code(user)
    @user = user
    @verification_code = user.verification_code
    
    mail(
      to: user.email_address,
      subject: "Your verification code"
    )
  end
end