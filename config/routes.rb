Rails.application.routes.draw do
  devise_for :users
  # HighVoltage
  # See PagesController and app/views/pages/*
  get "*id" => "pages#show", as: :page, format: false

  unauthenticated do
    get "/" => "pages#show", id: "landing"
  end

  authenticated do
    get "/" => "dashboard#show"
  end
end
