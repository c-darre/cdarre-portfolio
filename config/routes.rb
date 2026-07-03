Rails.application.routes.draw do
  # --- Auth admin ---
  devise_for :admin_users,
             path: "admin",
             path_names: { sign_in: "login", sign_out: "logout" }

  # --- Back-office (protégé par Admin::BaseController) ---
  namespace :admin do
    root to: "dashboard#index"

    resources :case_studies do
      member     { patch :toggle_published }   # publier / repasser en brouillon en 1 clic
      collection { patch :reorder }            # glisser-déposer (SortableJS)
      resources :sections, controller: "case_study_sections", shallow: true do
        collection { patch :reorder }
      end
    end

    resources :visual_works do
      member     { patch :toggle_published }
      collection { patch :reorder }
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
