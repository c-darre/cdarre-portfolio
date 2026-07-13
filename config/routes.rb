Rails.application.routes.draw do
  # --- Auth admin ---
  devise_for :admin_users,
             path: "admin",
             path_names: { sign_in: "login", sign_out: "logout" }

  # --- Back-office ---
  namespace :admin do
    root to: "dashboard#index"

    resources :case_studies do
      member     { patch :toggle_published }
      collection { patch :reorder }
      resources :sections, controller: "case_study_sections", shallow: true do
        collection { patch :reorder }
      end
    end

    resources :visual_works do
      member     { patch :toggle_published }
      collection { patch :reorder }
    end

    resources :awards
    resources :contact_messages, only: %i[index destroy]
  end

  # --- Pages publiques ---
  root to: "pages#home"
  get "travaux",  to: "pages#works",   as: :works     # écran de choix
  get "a-propos", to: "pages#about",   as: :about
  get "contact",  to: "pages#contact", as: :contact

  resources :case_studies, only: %i[index show], param: :slug, path: "projets"
  resources :visual_works, only: %i[index show],               path: "galerie"
  resources :contact_messages, only: :create, path: "messages"

  # --- SEO / infra ---
  get "sitemap.xml", to: "sitemaps#show", defaults: { format: "xml" }, as: :sitemap
  get "up", to: "rails/health#show", as: :rails_health_check
end
