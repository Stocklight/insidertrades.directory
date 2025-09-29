class User < ApplicationRecord
  has_many :sessions, dependent: :destroy

  normalizes :email_address, with: ->(e) { e.strip.downcase }

  def generate_verification_code!
    self.verification_code = rand(100000..999999).to_s
    self.verification_code_generated_at = Time.current
    save!
  end

  def verification_code_valid?(code)
    return false unless verification_code.present? && verification_code_generated_at.present?
    return false if verification_code_expired?

    verification_code == code
  end

  def verification_code_expired?
    return true unless verification_code_generated_at.present?

    verification_code_generated_at < 15.minutes.ago
  end
end
