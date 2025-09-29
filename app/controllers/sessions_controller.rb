class SessionsController < ApplicationController
  require_authentication only: :destroy
  rate_limit to: 10, within: 3.minutes, only: :create, with: -> { redirect_to new_session_url, alert: "Try again later." }
  skip_before_action :verify_authenticity_token, only: [:create_for_google]

  def new
    # Show signin form with email subscription
  end

  def create
    email = params[:email_address]&.strip&.downcase
    
    if email.blank?
      flash[:alert] = "Please enter a valid email address"
      redirect_to signin_path and return
    end
    
    user = User.find_or_initialize_by(email_address: email)
    user.generate_verification_code!
    
    # Send verification email
    UsersMailer.verification_code(user).deliver_now
    
    # Store user ID in session for verification
    session[:pending_user_id] = user.id
    
    flash[:notice] = "We've sent a verification code to #{email}. Please check your email."
    redirect_to verify_path
  rescue => e
    Rails.logger.error "Error creating session: #{e.message}"
    flash[:alert] = "There was an error processing your request. Please try again."
    redirect_to signin_path
  end

  def verify
    redirect_to signin_path unless session[:pending_user_id]
  end

  def verify_code
    user_id = session[:pending_user_id]
    code = params[:verification_code]
    
    if user_id.blank? || code.blank?
      flash[:alert] = "Invalid verification attempt"
      redirect_to signin_path and return
    end
    
    user = User.find_by(id: user_id)
    
    unless user
      flash[:alert] = "User not found"
      redirect_to signin_path and return
    end
    
    if user.verification_code_expired?
      flash[:alert] = "Verification code has expired. Please request a new one."
      redirect_to signin_path and return
    end
    
    if user.verification_code_valid?(code)
      # Clear verification code
      user.update!(verification_code: nil, verification_code_generated_at: nil)
      
      # Sign them in using the proper authentication method
      start_new_session_for(user)
      session[:pending_user_id] = nil
      
      flash[:notice] = "Welcome! You've been successfully signed in."
      redirect_to root_path
    else
      flash[:alert] = "Invalid verification code. Please try again."
      redirect_to verify_path
    end
  rescue => e
    Rails.logger.error "Error verifying code: #{e.message}"
    flash[:alert] = "There was an error verifying your code. Please try again."
    redirect_to verify_path
  end

  def destroy
    terminate_session
    redirect_to root_path, notice: "You have been signed out."
  end

  def create_for_google
    google_signin = GoogleSignin.new(web_credential: params[:credential])

    if google_signin.valid?
      # Find or create user by email
      user = User.find_or_initialize_by(email_address: google_signin.email)
      
      # Update Google user ID if it's a new association
      user.google_user_id = google_signin.user_id if user.google_user_id.blank?
      user.first_name = google_signin.first_name if user.first_name.blank?
      user.last_name = google_signin.last_name if user.last_name.blank?
      user.photo_url = google_signin.photo_url if user.photo_url.blank?
      user.save!
      
      # Sign them in
      start_new_session_for(user)
      
      flash[:notice] = "Successfully signed in with Google!"
      redirect_to root_path
    else
      flash[:alert] = "Could not authenticate you from Google"
      redirect_to signin_path
    end
  rescue => e
    Rails.logger.error "Google signin error: #{e.message}"
    flash[:alert] = "Could not authenticate you from Google"
    redirect_to signin_path
  end
end
