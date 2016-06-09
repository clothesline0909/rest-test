Rails.application.routes.draw do
  
    resources :project
    resources :todo

    # RESTful API routes.
    scope "/api" do
        scope "/1.0" do
            scope "/projects" do
                get "/" => "api_projects#index"
                post "/" => "api_projects#create"
                scope "/:project_id" do
                    get "/" => "api_projects#show"
                    put "/" => "api_projects#update"
                    delete "/" => "api_projects#delete"
                    scope "/todos" do
                        get "/" => "api_todos#index"
                        post "/" => "api_todos#create"
                        scope "/:todo_id" do
                            get "/" => "api_todos#show"
                            put "/" => "api_todos#update"
                            delete "/" => "api_todos#delete"
                        end
                    end
                end
            end
        end
    end

    match "api/*path", to: "api_base#routing_error", via: :get
end
