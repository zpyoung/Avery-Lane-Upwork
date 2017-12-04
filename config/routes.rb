Rails.application.routes.draw do
  devise_for :users
  resource :profile, only: [:edit, :update]
  resources :users, except: :show do
    member do
      patch :resend_invite
    end
  end

  require 'sidekiq/web'
  mount Sidekiq::Web => "/sidekiq"

  get "/admin", to: "consignments#admin", as: :admin
  [:teams, :regions, :list_roles].each do |list_items|
    resources list_items, except: :show
  end

  resources :consignments do
    get "/summary", to: "consignments#summary", as: :summary
    resources :items, only: %i[new create destroy]
    resources :contracts, except: :index
  end



  # get "/settings", to: "settings#settings", as: :settings
  resources :settings

  get '/pdf_header', to: 'pdfs#pdf_header', as: :pdf_header
  post 'duplicate_consignment', to: 'consignments#duplicate_consignment', as: :duplicate_consignment
  post 'change_status', to: 'consignments#change_status', as: :change_status

  root "dashboard#index"
end
