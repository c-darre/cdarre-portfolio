Rails.application.routes.draw do
  # --- Auth admin ---
  devise_for :admin_users,
             path: "admin",
             path_names: { sign_in: "login", sign_out: "logout" }

  # --- Back-office (contrôleurs créés à l'étape 3) ---
  namespace :admin do
    root to: "dashboard#index"

    resources :case_studies do
      patch :reorder, on: :collection
      resources :sections, controller: "case_study_sections", shallow: true do
        patch :reorder, on: :collection
      end
    end

    resources :visual_works do
      patch :reorder, on: :collection
    end

    resources :awards
  end

  # --- Pages publiques (contrôleurs créés à l'étape 4) ---
  root to: "pages#home"
  get "a-propos", to: "pages#about",   as: :about
  get "contact",  to: "pages#contact", as: :contact

  resources :case_studies, only: %i[index show], param: :slug, path: "projets"
  resources :visual_works, only: %i[index show],               path: "galerie"

  # --- SEO / infra ---
  get "sitemap.xml", to: "sitemaps#show", defaults: { format: "xml" }, as: :sitemap
  get "up", to: "rails/health#show", as: :rails_health_check
end
