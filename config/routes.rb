Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  
  root 'welcome#index'
  get "/admin", to: 'admin#index'

	resources :merchants, only: [] do
		member do 
			get 'dashboard'
		end
    resources :invoices, only: [:show]
	end

  namespace :admin do
    resources :merchants, only: [:index]
    resources :invoices, only: [:index, :show]
  end

  get "/merchants/:id/items", to: "merchant_items#index"
  get "/merchants/:merchant_id/items/:item_id", to: "merchant_items#show"

end
