Rails.application.routes.draw do
  
    resources :project
    resources :todo

    # RESTful API routes.
    scope "/api" do
        scope "/v1" do
            scope "/projects" do
                get "/" => "api/v1/projects#index"
                post "/" => "api/v1/projects#create"
                scope "/:project_id" do
                    get "/" => "api/v1/projects#show"
                    put "/" => "api/v1/projects#update"
                    delete "/" => "api/v1/projects#delete"
                    scope "/todos" do
                        get "/" => "api/v1/todos#index"
                        post "/" => "api/v1/todos#create"
                        scope "/:todo_id" do
                            get "/" => "api/v1/todos#show"
                            put "/" => "api/v1/todos#update"
                            delete "/" => "api/v1/todos#delete"
                        end
                    end
                end
            end

            scope "/users" do
                get "/" => "api/v1/users#index"
                post "/" => "api/v1/users#create"
            end
        end
    end

    match "api/*path", to: "api/v1/base#routing_error", via: :get
end
