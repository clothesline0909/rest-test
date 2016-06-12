require "rails_helper"

RSpec.describe Api::V1::ProjectsController, type: :controller do
    include AuthenticationHelper

    before :each do
        set_auth_token
    end
    
    describe "GET #index" do
    	before :each do
    		create :project
        	create :project, name: "second project"
        	create :project, name: "third project"
    	end

        it "should return an HTTP 200 status code" do
            get :index
            expect(response).to be_success
            expect(response).to have_http_status(200)
        end

        it "should return a list of projects" do
        	get :index
        	projects = JSON.parse(response.body)
        	expect(projects.length).to eq(3)
        end

        it "should return the correct project names" do
        	get :index
        	projects = JSON.parse(response.body)
        	project_names = projects.map { |project| project["name"] }
        	expect(project_names).to match_array(["first project", "second project", "third project"])
        end

        it "should only return the visible fields" do
            get :index
            project = JSON.parse(response.body)[0]
            expect(project.keys).to match_array(["id", "name"])
        end
    
        describe "project_name query parameter" do
            it "should return one project whose name contains the string" do
                get :index, project_name: "first"
                projects = JSON.parse(response.body)
                expect(projects.length).to eq(1)
                expect(projects.first["name"]).to eq("first project")
            end

            it "should not return any projects" do
                get :index, project_name: "fourth"
                projects = JSON.parse(response.body)
                expect(projects.length).to eq(0)
            end
        end

        describe "start_date query parameter" do
            it "should return no projects" do
                time = Time.new + 1.day
                date = time.strftime("%Y-%m-%d")
                get :index, start_date: date
                projects = JSON.parse(response.body)
                expect(projects.length).to eq(0)
            end

            it "should return all the projects" do
                time = Time.new - 1.day
                date = time.strftime("%Y-%m-%d")
                get :index, start_date: date
                projects = JSON.parse(response.body)
                expect(projects.length).to eq(3)
            end
        end

        describe "end_date query parameter" do
            it "should return no projects" do
                time = Time.new - 1.day
                date = time.strftime("%Y-%m-%d")
                get :index, end_date: date
                projects = JSON.parse(response.body)
                expect(projects.length).to eq(0)
            end

            it "should return all the projects" do
                time = Time.new + 1.day
                date = time.strftime("%Y-%m-%d")
                get :index, end_date: date
                projects = JSON.parse(response.body)
                expect(projects.length).to eq(3)
            end
        end
    end

    describe "POST #create" do
        before :each do
            @project_params = {
                name: "posted project"
            }
        end

        it "should return an HTTP 200 status code" do
            post :create, project: @project_params
            expect(response).to be_success
            expect(response).to have_http_status(201)
        end

        it "should create a project" do
            expect do 
                post :create, project: @project_params
            end.to change{ Project.all.count }.from(0).to(1)
        end

        it "should return the created project" do
            post :create, project: @project_params
            project = JSON.parse(response.body)
            expect(project["name"]).to eq("posted project")
        end

        it "should return an HTTP 400 status code on bad input" do
            @project_params = {
                names: "posted project"
            }
            post :create, project: @project_params
            expect(response).to have_http_status(400)
        end
    end

    describe "GET #show" do
    	before :each do
    		@project = create :project
    	end

    	it "should return an HTTP 200 status code" do
    		get :show, project_id: @project.id
            expect(response).to be_success
            expect(response).to have_http_status(200)
    	end

    	it "should return the correct project" do
    		get :show, project_id: @project.id
    		project = JSON.parse(response.body)
    		expect(project["name"]).to eq("first project")
    	end

        it "should return an HTTP 404 status code on non-existant project ID" do
            get :show, project_id: 100
            expect(response).to have_http_status(404)
        end
    end

    describe "PUT #update" do
        before :each do
            @project = create :project
            @project_params = {
                name: "updated project"
            }
        end

        it "should return an HTTP 200 status code" do
            put :update, project_id: @project.id, project: @project_params
            expect(response).to be_success
            expect(response).to have_http_status(200)
        end

        it "should update the project name" do
            put :update, project_id: @project.id, project: @project_params
            @project = Project.find(@project.id)
            expect(@project.name).to eq("updated project")
        end

        it "should return the updated project" do
            put :update, project_id: @project.id, project: @project_params
            project = JSON.parse(response.body)
            expect(project["name"]).to eq("updated project")
        end

        it "should return an HTTP 404 status code on non-existant project ID" do
            get :update, project_id: 100, project: @project_params
            expect(response).to have_http_status(404)
        end

        it "should return an HTTP 400 status code on bad input" do
            @project_params = {
                names: "updated project"
            }
            post :update, project_id: @project.id, project: @project_params
            expect(response).to have_http_status(400)
        end
    end

    describe "DELETE #delete" do
        before :each do
            @project = create :project
            create :project, name: "second project"
            create :project, name: "third project"
        end

        it "should return an HTTP 200 status code" do
            put :delete, project_id: @project.id
            expect(response).to be_success
            expect(response).to have_http_status(200)
        end

        it "should delete the project" do
            put :delete, project_id: @project.id
            get :index
            projects = JSON.parse(response.body)
            expect(projects.length).to eq(2)
        end

        it "should return an HTTP 404 status code on non-existant project ID" do
            get :delete, project_id: 100
            expect(response).to have_http_status(404)
        end
    end
end