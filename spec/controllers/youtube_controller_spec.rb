require 'rails_helper'

RSpec.describe YoutubeController, :type => :controller do

  describe "GET download_to_dropbox" do
    it "returns http success" do
      get :download_to_dropbox
      expect(response).to have_http_status(:success)
    end
  end

end
