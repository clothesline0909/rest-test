require 'rails_helper'

RSpec.describe Api::V1::TodosController, type: :controller do
	include AuthenticationHelper

	before :each do
		set_auth_token
	end
	
	describe "GET #index" do
		before :each do
			@project = create :project
			create :todo, project_id: @project.id
			create :todo, name: "second todo", project_id: @project.id
			create :todo, name: "third todo", project_id: @project.id
		end

		it "should return an HTTP 200 status code" do
			get :index, project_id: @project.id
			expect(response).to be_success
			expect(response).to have_http_status(200)
		end

		it "should return a list of todos" do
			get :index, project_id: @project.id
			todos = JSON.parse(response.body)
			expect(todos.length).to eq(3)
		end

		it "should return the correct todo names" do
			get :index, project_id: @project.id
			todos = JSON.parse(response.body)
			todo_names = todos.map { |todo| todo["name"] }
			expect(todo_names).to match_array(["first todo", "second todo", "third todo"])
		end
	end

	describe "POST #create" do
		before :each do
			@project = create :project
			@todo_params = {
				name: "first todo"
			}
		end

		it "should return an HTTP 201 status code" do
			post :create, project_id: @project.id, todo: @todo_params
			expect(response).to be_success
			expect(response).to have_http_status(201)
		end

		it "should create a todo" do
			expect do
				post :create, project_id: @project.id, todo: @todo_params
			end.to change{ Todo.all.count }.from(0).to(1)
		end

		it "should return the correct todo name" do
			post :create, project_id: @project.id, todo: @todo_params
			todo = JSON.parse(response.body)
			expect(todo["name"]).to eq("first todo")
		end

		it "should return an HTTP 400 status code on bad input" do
			@todo_params = {
				names: "first todo"
			}
			post :create, project_id: @project.id, todo: @todo_params
			expect(response).to have_http_status(400)
		end
	end

	describe "GET #show" do
		before :each do
			@project = create :project
			@todo = create :todo, project_id: @project.id
		end

		it "should return an HTTP 200 status code" do
			get :show, project_id: @project.id, todo_id: @todo.id
			expect(response).to be_success
			expect(response).to have_http_status(200)
		end

		it "should return the correct todo" do
			get :show, project_id: @project.id, todo_id: @todo.id
			todo = JSON.parse(response.body)
			expect(todo["name"]).to eq("first todo")
		end

		it "should return an HTTP 404 status code on non-existant todo ID" do
			get :show, project_id: @project.id, todo_id: 100
			expect(response).to have_http_status(404)
		end

		it "should return an HTTP 404 status code on incorrect project ID" do
			@another_project = create :project, name: "second project"
			get :show, project_id: @another_project.id, todo_id: @todo.id
			expect(response).to have_http_status(404)
		end
	end

	describe "PUT #update" do
		before :each do
			@project = create :project
			@todo = create :todo, project_id: @project.id
			@todo_params = {
				name: "updated todo"
			}
		end

		it "should return an HTTP 200 status code" do
			put :update, project_id: @project.id, todo_id: @todo.id, todo: @todo_params
			expect(response).to be_success
			expect(response).to have_http_status(200)
		end

		it "should update the todo name" do
			put :update, project_id: @project.id, todo_id: @todo.id, todo: @todo_params
			@todo = Todo.find(@todo.id)
			expect(@todo.name).to eq("updated todo")
		end

		it "should return the updated todo name" do
			put :update, project_id: @project.id, todo_id: @todo.id, todo: @todo_params
			todo = JSON.parse(response.body)
			expect(todo["name"]).to eq("updated todo")
		end

		it "should return an HTTP 404 status code on non-existant todo ID" do
            get :update, project_id: @project.id, todo_id: 100, todo: @todo_params
            expect(response).to have_http_status(404)
        end

        it "should return an HTTP 404 status code on incorrect project ID" do
        	@another_project = create :project, name: "another project"
			get :update, project_id: @another_project.id, todo_id: @todo.id, todo: @todo_params
			expect(response).to have_http_status(404)
        end

        it "should return an HTTP 400 status code on no input" do
        	post :update, project_id: @todo.id, todo_id: @todo.id
            expect(response).to have_http_status(400)
        end

        it "should return an HTTP 400 status code on bad input" do
            @todo_params = {
                names: "updated project"
            }
            post :update, project_id: @todo.id, todo_id: @todo.id, todo: @todo_params
            expect(response).to have_http_status(400)
        end
	end

	describe "DELETE #delete" do
        before :each do
        	@project = create :project
            @todo = create :todo, project_id: @project.id
            create :todo, name: "second todo", project_id: @project.id
            create :todo, name: "third todo", project_id: @project.id
        end

        it "should return an HTTP 200 status code" do
            put :delete, project_id: @project.id, todo_id: @todo.id
            expect(response).to be_success
            expect(response).to have_http_status(200)
        end

        it "should delete the todo" do
            put :delete, project_id: @project.id, todo_id: @todo.id
            get :index, project_id: @project.id
            todos = JSON.parse(response.body)
            expect(todos.length).to eq(2)
        end

        it "should return an HTTP 404 status code on non-existant todo ID" do
            get :delete, project_id: @project.id, todo_id: 100
            expect(response).to have_http_status(404)
        end

        it "should return an HTTP 404 status code on incorrect project ID" do
        	@another_project = create :project, name: "another project"
			get :delete, project_id: @another_project.id, todo_id: @todo.id
			expect(response).to have_http_status(404)
        end
    end
end