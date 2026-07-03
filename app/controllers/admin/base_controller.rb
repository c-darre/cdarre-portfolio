module Admin
  # Contrôleur parent de tout le back-office.
  # Un seul verrou (authenticate_admin_user!) protège TOUTES les actions admin :
  # pas connecté → redirection vers /admin/login.
  class BaseController < ApplicationController
    before_action :authenticate_admin_user!
    layout "admin"
  end
end
