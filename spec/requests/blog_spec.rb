require 'rails_helper'

RSpec.describe "Blogs", type: :request do
  describe "GET /index" do
    it "returns http success" do
      get "/built-with-rails"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /show" do
    it "returns http success" do
      post = Post.create!(title: "Test Post", slug: "kamal-digital-ocean-open-tofu-terraform", status: "published", content: "Test content")
      get "/built-with-rails/kamal-digital-ocean-open-tofu-terraform"
      expect(response).to have_http_status(:success)
    end
  end
end
