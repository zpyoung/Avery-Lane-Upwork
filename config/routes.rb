Rails.application.routes.draw do
  devise_for :users
  resource :profile, only: [:edit, :update]
  resources :users, except: :show do
    member do
      patch :resend_invite
    end
  end

  resources :consignments do
    get "/summary", to: "consignments#summary", as: :summary
  end
  get "/admin", to: "consignments#admin", as: :admin
  [:teams, :regions, :list_roles].each do |list_items|
    resources list_items, except: :show
  end

  post 'duplicate_consignment', to: 'consignments#duplicate_consignment', as: :duplicate_consignment
  post 'change_status', to: 'consignments#change_status', as: :change_status

  root "dashboard#index"
end
