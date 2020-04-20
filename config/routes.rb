Rails.application.routes.draw do
  resources :stories do
    member do
      get "publish"
    end
  end

  devise_for :users

  unauthenticated do
    get "/" => "pages#show", id: "landing"
  end

  authenticated do
    get "/" => "dashboard#show"
  end

  # HighVoltage
  # See PagesController and app/views/pages/*
  get "*id" => "pages#show", as: :page, format: false
end
