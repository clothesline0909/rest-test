require "rails_helper"

RSpec.describe Api::V1::ProjectsController, type: :controller do
    include AuthenticationHelper

    before :each do
        set_auth_token
        create :project
        create :project, name: "second project"
        create :project, name: "third project"
    end

    describe "authentication" do
    	it "should successfully authenticate on valid token" do
    		get :index
    		expect(response).to have_http_status(200)
    		projects = JSON.parse(response.body)
    		expect(projects.length).to eq(3)
    	end

    	it "should fail authentication on incorrect token" do
    		user = APIUser.create
    		token = (user.api_token == "incorrecttoken") ? "othertoken" : "incorrecttoken"
    		request.env['HTTP_AUTHORIZATION'] = "Token token=#{token}"
    		get :index
    		expect(response).to have_http_status(401)
    	end

    end

end