Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  
  root 'welcome#index'
  get "/admin", to: 'admin#index'

	resources :merchants, only: [:edit, :update, :new, :create] do
		member do 
			get 'dashboard'
		end

    resources :items, only: [:index, :new, :create, :show, :edit, :update] 

    resources :invoices, only: [:index, :show, :update]

    resources :bulk_discounts, only: [:index, :show, :new, :create, :destroy, :edit, :update]
	end


  namespace :admin do
    resources :invoices, only: [:index, :show, :update]
    resources :merchants, only: [:index, :show]
  end


	# get "/merchants/:id/invoices", to: "merchant_invoices#index"

end
