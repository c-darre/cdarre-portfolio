module ApplicationHelper
  # Source unique des infos de profil du site public.
  PROFILE = {
    name:     "Cyprien Darré",
    tagline:  "Product Designer × Design Engineer",
    pitch:    "Des idées au produit : concevoir, écrire, coder.",
    location: "Bordeaux → Paris",
    email:    "cyprien.darre@gmail.com",
    linkedin: "https://www.linkedin.com/in/cyprien-darre",
    github:   "https://github.com/c-darre"
  }.freeze

  def profile = PROFILE

  def page_title
    if content_for?(:title)
      "#{content_for(:title)} · #{PROFILE[:name]}"
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

  # Portrait de la page À propos : dépose la photo sous
  # app/assets/images/portrait-about.jpg et elle apparaît (sinon placeholder).
  # Cercle blanc du bloc contact : depose sous app/assets/images/.
  def contact_deco_path
    nom = "works-base-blanc.png"
    nom if Rails.root.join("app/assets/images/#{nom}").exist?
  end

  def about_portrait_path
    "portrait-about.jpg" if Rails.root.join("app/assets/images/portrait-about.jpg").exist?
  end


  # Video de landing : servie depuis public/ (pas d'empreinte, pas de passage
  # par le pipeline — inutile pour un media qui ne change jamais, et evite de
  # faire grossir le build). Le nom de fichier n'est ecrit qu'ICI.
  INTRO_VIDEO = "cyprien-darre-logo-loop.mp4".freeze

  def intro_video_path
    "/media/#{INTRO_VIDEO}" if Rails.public_path.join("media", INTRO_VIDEO).exist?
  end

  def nav_link(label, path)
    active = current_page?(path)
    link_to label, path,
            class: class_names("site-nav-link", active: active),
            aria: { current: (active ? "page" : nil) }
  end

  def attachment_alt(attachment, fallback: "Visuel")
    name = attachment.filename.base.to_s.tr("-_", " ").squish
    name.present? ? name.upcase_first : fallback
  end
end
