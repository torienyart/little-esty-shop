Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  
  get "/admin", to: 'admin#index'
	 
	get "/merchants/:id/dashboard", to: 'merchants#show'

  namespace :admin do
    resources :merchants, only: [:index]
    resources :invoices, only: [:index]
  end

end
