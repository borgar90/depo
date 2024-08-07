Rails.application.routes.draw do
  get 'return_order/show'
  get 'return_order/edit'
  get 'return_order/update'
  get 'profiles/show'
  get 'profiles/edit'
  get 'profiles/update'
  get 'admin' => 'admin#index'
  controller :sessions do
    get 'login' => :new
    post 'login' => :create
    delete 'logout' => :destroy
  end
  get 'sessions/new'
  get 'sessions/create'
  get 'sessions/destroy'

  resources :users
  resources :profiles, only: [:show, :edit, :update]

  resources :orders
  resources :return_order, only: [:index, :show]
  resources :line_items
  resources :carts do
    member do
      patch 'increase_quantity'
      patch 'decrease_quantity'
    end
  end

  resources :products do
    member do
      get :who_bought
    end
  end

  scope '(:locale)' do
    resources :orders
    resources :line_items
    resources :carts
    root 'store#index', as: 'store_index', via: :all
  end
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
