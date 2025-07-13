require 'rails_helper'

RSpec.describe "RuleSets", type: :request do
  describe "GET /index" do
    it "returns http success" do
      get "/rule_sets/index"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /show" do
    it "returns http success" do
      get "/rule_sets/show"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /new" do
    it "returns http success" do
      get "/rule_sets/new"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /edit" do
    it "returns http success" do
      get "/rule_sets/edit"
      expect(response).to have_http_status(:success)
    end
  end

end
