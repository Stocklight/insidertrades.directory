require 'rails_helper'

RSpec.describe "Blazer Authentication", type: :request do
  let(:admin_user) { User.create!(email_address: "admin@example.com") }
  let(:regular_user) { User.create!(email_address: "user@example.com") }
  let(:admin_session) { Session.create!(user: admin_user) }
  let(:regular_session) { Session.create!(user: regular_user) }

  before do
    # Set up admin user IDs in config
    Rails.application.config.admin_user_ids = [ admin_user.id ]
  end


  describe "accessing blazer routes" do
    context "without authentication" do
      it "denies access to blazer dashboard" do
        get "/blazer"
        expect(response).to have_http_status(403)
        expect(response.body).to include("Access denied - Admin privileges required")
      end

      it "denies access to blazer queries" do
        get "/blazer/queries"
        expect(response).to have_http_status(403)
        expect(response.body).to include("Access denied - Admin privileges required")
      end
    end

    context "with regular user authentication" do
      let(:signed_cookie_value) do
        Rails.application.message_verifier("signed cookie").generate(regular_session.id)
      end

      it "denies access to blazer dashboard for non-admin users" do
        get "/blazer", headers: { "Cookie" => "session_id=#{signed_cookie_value}" }
        expect(response).to have_http_status(403)
        expect(response.body).to include("Access denied - Admin privileges required")
      end

      it "denies access to blazer queries for non-admin users" do
        get "/blazer/queries", headers: { "Cookie" => "session_id=#{signed_cookie_value}" }
        expect(response).to have_http_status(403)
        expect(response.body).to include("Access denied - Admin privileges required")
      end
    end

    context "with admin user authentication" do
      let(:signed_cookie_value) do
        Rails.application.message_verifier("signed cookie").generate(admin_session.id)
      end

      it "allows access to blazer dashboard for admin users" do
        get "/blazer", headers: { "Cookie" => "session_id=#{signed_cookie_value}" }
        expect(response).to have_http_status(200)
      end

      it "allows access to blazer queries for admin users" do
        get "/blazer/queries", headers: { "Cookie" => "session_id=#{signed_cookie_value}" }
        # Blazer queries page redirects to queries list, which is expected behavior
        expect([ 200, 302 ]).to include(response.status)
      end
    end

    context "with invalid session" do
      let(:signed_cookie_value) do
        Rails.application.message_verifier("signed cookie").generate("invalid_session_id")
      end

      it "denies access with invalid session" do
        get "/blazer", headers: { "Cookie" => "session_id=#{signed_cookie_value}" }
        expect(response).to have_http_status(403)
        expect(response.body).to include("Access denied - Admin privileges required")
      end
    end

    context "with deleted session" do
      it "denies access when session is deleted" do
        session = Session.create!(user: admin_user)
        signed_cookie_value = Rails.application.message_verifier("signed cookie").generate(session.id)
        session.destroy
        get "/blazer", headers: { "Cookie" => "session_id=#{signed_cookie_value}" }
        expect(response).to have_http_status(403)
        expect(response.body).to include("Access denied - Admin privileges required")
      end
    end
  end
end
