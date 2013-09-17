Zenschool::Application.routes.draw do
  get "welcome/index"
  root to: "welcome#index"

  resources :students

  resources :groups

end
