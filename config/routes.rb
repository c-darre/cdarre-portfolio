Rails.application.routes.draw do
  # --- Canonisation : www -> apex, en 301 ---
  constraints(host: /\Awww\./) do
    match "(*path)", via: :all, to: redirect(status: 301) { |_, req|
      "https://" + req.host.delete_prefix("www.") + req.fullpath
    }
  end

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
    resources :contact_messages, only: %i[index destroy] do
      collection { delete :purge }
    end
  end

  # --- Pages publiques ---
  root to: "pages#home"
  get "travaux",  to: "pages#works",   as: :works     # écran de choix
  get "a-propos", to: "pages#about",   as: :about
  get "contact",  to: "pages#contact", as: :contact

  get "mentions-legales", to: "pages#legal",   as: :legal
  get "confidentialite",  to: "pages#privacy", as: :privacy
  get "faq",              to: "pages#faq",     as: :faq

  resources :case_studies, only: %i[index show], param: :slug, path: "projets"
  resources :visual_works, only: %i[index],                    path: "galerie"
  resources :contact_messages, only: :create, path: "messages"

  # --- SEO / infra ---
  get "sitemap.xml", to: "sitemaps#show", defaults: { format: "xml" }, as: :sitemap
  get "up", to: "rails/health#show", as: :rails_health_check
end
