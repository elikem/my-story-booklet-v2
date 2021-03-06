# == Route Map
#
#                                Prefix Verb   URI Pattern                                                                              Controller#Action
# publications_ready_for_pdf_conversion GET    /publications/waiting_for_pdf_conversion(.:format)                                         publications#ready_for_pdf_conversion
#                                       GET    /publications/:id/json(.:format)                                                         publications#show_json
#                                       GET    /publications/:id/idml(.:format)                                                         publications#get_idml
#                         publish_story GET    /stories/:id/publish(.:format)                                                           stories#publish
#                               stories POST   /stories(.:format)                                                                       stories#create
#                            edit_story GET    /stories/:id/edit(.:format)                                                              stories#edit
#                                 story PATCH  /stories/:id(.:format)                                                                   stories#update
#                                       PUT    /stories/:id(.:format)                                                                   stories#update
#                                       DELETE /stories/:id(.:format)                                                                   stories#destroy
#                      new_user_session GET    /users/sign_in(.:format)                                                                 devise/sessions#new
#                          user_session POST   /users/sign_in(.:format)                                                                 devise/sessions#create
#                  destroy_user_session DELETE /users/sign_out(.:format)                                                                devise/sessions#destroy
#                     new_user_password GET    /users/password/new(.:format)                                                            devise/passwords#new
#                    edit_user_password GET    /users/password/edit(.:format)                                                           devise/passwords#edit
#                         user_password PATCH  /users/password(.:format)                                                                devise/passwords#update
#                                       PUT    /users/password(.:format)                                                                devise/passwords#update
#                                       POST   /users/password(.:format)                                                                devise/passwords#create
#              cancel_user_registration GET    /users/cancel(.:format)                                                                  devise/registrations#cancel
#                 new_user_registration GET    /users/sign_up(.:format)                                                                 devise/registrations#new
#                edit_user_registration GET    /users/edit(.:format)                                                                    devise/registrations#edit
#                     user_registration PATCH  /users(.:format)                                                                         devise/registrations#update
#                                       PUT    /users(.:format)                                                                         devise/registrations#update
#                                       DELETE /users(.:format)                                                                         devise/registrations#destroy
#                                       POST   /users(.:format)                                                                         devise/registrations#create
#                 new_user_confirmation GET    /users/confirmation/new(.:format)                                                        devise/confirmations#new
#                     user_confirmation GET    /users/confirmation(.:format)                                                            devise/confirmations#show
#                                       POST   /users/confirmation(.:format)                                                            devise/confirmations#create
#                       new_user_unlock GET    /users/unlock/new(.:format)                                                              devise/unlocks#new
#                           user_unlock GET    /users/unlock(.:format)                                                                  devise/unlocks#show
#                                       POST   /users/unlock(.:format)                                                                  devise/unlocks#create
#                                       GET    /                                                                                        pages#show {:id=>"landing"}
#                                       GET    /                                                                                        dashboard#show
#                                  page GET    /*id                                                                                     pages#show
#                           sidekiq_web        /sidekiq                                                                                 Sidekiq::Web
#                    rails_service_blob GET    /rails/active_storage/blobs/:signed_id/*filename(.:format)                               active_storage/blobs#show
#             rails_blob_representation GET    /rails/active_storage/representations/:signed_blob_id/:variation_key/*filename(.:format) active_storage/representations#show
#                    rails_disk_service GET    /rails/active_storage/disk/:encoded_key/*filename(.:format)                              active_storage/disk#show
#             update_rails_disk_service PUT    /rails/active_storage/disk/:encoded_token(.:format)                                      active_storage/disk#update
#                  rails_direct_uploads POST   /rails/active_storage/direct_uploads(.:format)                                           active_storage/direct_uploads#create

Rails.application.routes.draw do
  post "publications/publish-pdf" => "publications#update_publication_with_pdf"
  get "publications/waiting-for-pdf-conversion" => "publications#waiting_for_pdf_conversion"
  get "publications/:id/json" => "publications#show_json"
  get "publications/:id/idml" => "publications#show_idml"

  resources :profiles, only: [:show, :edit, :update] do
    member do
      get "pdf"
    end
  end

  resources :stories, except: [:index, :new, :show] do
    member do
      get "publish"
    end
  end

  require "sidekiq/web"
  mount Sidekiq::Web => "/sidekiq"

  devise_for :users, :controllers => { :registrations => "users/registrations" }

  unauthenticated do
    get "/" => "pages#show", id: "landing"
  end

  authenticated do
    get "/" => "dashboard#show"
  end

  # HighVoltage
  # See PagesController and app/views/pages/*
  # get "*id" => "pages#show", as: :page, format: false

  # display errors
  match ":status", to: "errors#show", constraints: { status: /\d{3}/ }, via: :all
  get "errors/:id" => "errors#show"
end
