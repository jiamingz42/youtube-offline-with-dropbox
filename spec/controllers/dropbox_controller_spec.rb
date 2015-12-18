require 'rails_helper'

RSpec.describe DropboxController, :type => :controller do

  describe "GET save_url" do
    it "returns http success" do
      get :save_url
      expect(response).to have_http_status(:success)
    end
  end

end
