module ApplicationHelper
  # Source unique des infos de profil du site public.
  PROFILE = {
    name:     "Cyprien Darré",
    tagline:  "Communication interne, éditorial et conduite du changement",
    pitch:    "De l'idée à l'usage : concevoir, déployer, faire adopter.",
    location: "Île-de-France, Rennes, Orléans",
    email:    "cyprien.darre@gmail.com",
    linkedin: "https://www.linkedin.com/in/c-darre",
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

    # 149 caracteres : sous le seuil de troncature de Google. Le pitch n'est
    # plus concatene ici, il faisait deborder la phrase au-dela de 200.
    "Portfolio de #{PROFILE[:name]} : communication interne et éditoriale, " \
      "conduite du changement et adoption des outils en direction des " \
      "systèmes d'information."
  end

  # Le fichier vit sous lib/documents et sort par PagesController#cv.
  # L'URL publique, elle, n'a pas bouge.
  def cv_path_if_available
    "/cv-cyprien-darre.pdf" if File.exist?(PagesController::CV_PATH)
  end

  def cv_file_size
    File.size(PagesController::CV_PATH)
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

  # Version portrait, plus legere, servie aux ecrans etroits : la version 16:9
  # y perdrait 70 % de sa largeur au recadrage, pour un poids bien superieur.
  INTRO_VIDEO_MOBILE = "cyprien-darre-logo-loop-mobile.mp4".freeze

  def intro_video_mobile_path
    nom = INTRO_VIDEO_MOBILE
    "/media/#{nom}" if Rails.public_path.join("media", nom).exist?
  end

  def nav_link(label, path)
    active = current_page?(path)
    link_to label, path,
            class: class_names("site-nav-link", active: active),
            aria: { current: (active ? "page" : nil) }
  end

  # Texte alternatif d'un visuel, dans cet ordre : la legende saisie en
  # back-office, puis le repli fourni par la vue (titre de l'oeuvre ou de
  # l'etude), puis un mot neutre.
  #
  # Le NOM DE FICHIER ne sert plus : il arrivait en premier et gagnait
  # toujours, ce qui affichait « Magazine Mockup 6 copie » aux lecteurs
  # d'ecran et aux moteurs.
  def attachment_alt(attachment, fallback: nil)
    attachment_caption(attachment).presence ||
      fallback.presence ||
      "Visuel"
  end

  # Legende d'un visuel d'etude de cas. Stockee dans les metadonnees du blob
  # plutot que dans une table dediee : Active Storage les serialise deja, et
  # une piece jointe sans legende n'a alors aucune ligne fantome en base.
  # Saisie dans le back-office, section par section.
  def attachment_caption(attachment)
    attachment.blob.metadata["caption"].presence
  end
end
