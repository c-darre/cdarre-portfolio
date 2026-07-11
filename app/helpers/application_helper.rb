module ApplicationHelper
  # Source unique des infos de profil du site public.
  PROFILE = {
    name:     "Cyprien Darré",
    tagline:  "Product Designer × Design Engineer",
    pitch:    "Je conçois l'expérience, je la rédige, et je la code.",
    location: "Bordeaux → Paris",
    email:    "cyprien.darre@gmail.com",
    linkedin: "https://www.linkedin.com/in/cyprien-darre",
    github:   "https://github.com/c-darre"
  }.freeze

  def profile = PROFILE

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

  def cv_path_if_available
    "/cv-cyprien-darre.pdf" if File.exist?(Rails.root.join("public/cv-cyprien-darre.pdf"))
  end

  # Lien de navigation DA (plus de classes Bootstrap).
  def nav_link(label, path)
    active = current_page?(path)
    link_to label, path,
            class: class_names("site-nav-link", active: active),
            aria: { current: (active ? "page" : nil) }
  end

  # Alt d'une image Active Storage dérivé du nom de fichier.
  def attachment_alt(attachment, fallback: "Visuel")
    name = attachment.filename.base.to_s.tr("-_", " ").squish
    name.present? ? name.upcase_first : fallback
  end
end
