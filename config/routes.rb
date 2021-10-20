Rails.application.routes.draw do

  root to: "public/homes#top"

  devise_for :admin, skip:[:registrations, :passwords], controllers:{
    sessions: "admin/sessions"
  }

  namespace :admin do
    root to: 'orders#index'
    resources :items, except:[:destroy]
    resources :genres, only:[:index, :edit, :create, :update]
    resources :customers, only:[:index, :show, :edit, :update]
    resources :orders, only:[:show, :update]
    resources :order_items, only:[:update]
    get '/search', to: "searches#search"
  end

  devise_for :customer, skip:[:passwords], controllers:{
    registrations: "public/registrations",
    sessions: "public/sessions"
  }

  scope module: :public do
    get "/about", to: "homes#about"
    get "/customer/withdraw_confirm", to: "customers#withdraw_confirm"
    patch "/customer/withdraw", to: "customers#withdraw"
    resource :customer, only:[:show, :edit, :update]
    resources :items, only:[:index, :show]
    resources :cart_items, except:[:show, :new, :edit]
    delete "/cart_items", to: "cart_items#destroy_all"
    resources :orders, except:[:edit, :update, :destroy]
    get "/orders/thankyou", to: "orders#thankyou"
    get "/orders/check", to: "orders#check"
    resources :shipping_addresses, except:[:new, :show]
    # ジャンル検索用ルーティング
    get '/genre_search', to: "searches#genre_search"
    # 商品名検索用ルーティング
    get '/item_search', to: "searches#item_search"
  end

end
