module ApplicationHelper
  # Source unique des infos de profil du site public.
  # email: nil tant que non renseigné — les vues ne l'affichent que s'il existe.
  PROFILE = {
    name:     "Cyprien Darré",
    tagline:  "Product Designer × Design Engineer",
    pitch:    "Je conçois l'expérience, je la rédige, et je la code.",
    location: "Bordeaux · ouvert à Paris et Rennes",
    email:    nil, # ⚠️ renseigne ton vrai email, ex. "prenom.nom@domaine.fr"
    linkedin: "https://www.linkedin.com/in/cyprien-d-9695a385/",
    github:   "https://github.com/c-darre"
  }.freeze

  def profile = PROFILE

  # <title> : "Page — Cyprien Darré", ou le titre par défaut du site.
  def page_title
    if content_for?(:title)
      "#{content_for(:title)} — #{PROFILE[:name]}"
    else
      "#{PROFILE[:name]} · #{PROFILE[:tagline]}"
    end
  end

  def meta_description
    return content_for(:meta_description) if content_for?(:meta_description)

    "Portfolio de #{PROFILE[:name]}, #{PROFILE[:tagline]} : études de cas UX/UI, " \
      "design system et développement Ruby on Rails. #{PROFILE[:pitch]}"
  end

  # Lien CV rendu uniquement si le PDF est réellement présent dans public/.
  def cv_path_if_available
    "/cv-cyprien-darre.pdf" if File.exist?(Rails.root.join("public/cv-cyprien-darre.pdf"))
  end

  # Lien de navigation avec état actif accessible (aria-current="page").
  def nav_link(label, path)
    active = current_page?(path)
    link_to label, path,
            class: class_names("nav-link", active: active),
            aria: { current: (active ? "page" : nil) }
  end
end
