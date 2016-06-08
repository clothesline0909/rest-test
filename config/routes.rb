Rails.application.routes.draw do
  
    resources :project
    resources :todo

    # RESTful API
    scope "/api" do
        scope "/1.0" do
            scope "/projects" do
                get "/" => "api_projects#index"
                post "/" => "api_projects#create"
                scope "/:name" do
                    get "/" => "api_projects#show"
                    put "/" => "api_projects#update"
                    scope "/todos" do
                        get "/" => "api_todos#index"
                        post "/" => "api_todos#create"
                        scope "/:todo_name" do
                            get "/" => "api_todos#show"
                            put "/" => "api_todos#update"
                        end
                    end
                end
            end
        end
    end
end
