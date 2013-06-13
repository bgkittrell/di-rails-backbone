DI::Application.routes.draw do
  namespace :impact do
    resources :filters
  end


  namespace :impact do
    resources :videos
  end


  namespace :impact do
    resources :categories
  end


  namespace :champions do
    resources :videos
  end


  namespace :champions do
    resources :categories
  end


  get "screens/:action" => 'screens'

  get '/admin' => 'admin#index'

end
