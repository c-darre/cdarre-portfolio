class ApplicationController < ActionController::Base
  # Autorise les navigateurs modernes (généré par Rails 8, on le garde).
  allow_browser versions: :modern

  # Après connexion, un admin va sur le tableau de bord (pas sur la home publique).
  # Seul le scope admin se connecte, donc ce redirect ne concerne que lui.
  def after_sign_in_path_for(_resource)
    admin_root_path
  end
end
