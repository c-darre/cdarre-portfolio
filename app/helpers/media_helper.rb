module MediaHelper
  # --- Images responsives ------------------------------------------------
  # Sert chaque visuel a la taille REELLEMENT affichee plutot qu'en original.
  # Mesure avant correction : les images etaient 4 a 6 fois trop grandes sur
  # mobile, densite Retina comprise.
  #
  #   largeurs : les tailles a generer, en pixels ;
  #   sizes    : la largeur d'affichage prevue, par palier — c'est elle qui
  #              permet au navigateur de choisir AVANT de connaitre l'image.
  #
  # Le WebP pese environ 30 % de moins que le JPEG a qualite egale, et tous
  # les navigateurs en service le lisent.
  # Le traitement d'images est-il reellement disponible ? La question se pose
  # AVANT de fabriquer les URL : un `rescue` autour d'elles ne protege de rien,
  # puisqu'elles se construisent toujours sans erreur — l'echec ne survient que
  # plus tard, quand le navigateur les demande, page deja envoyee. Sans ce
  # test, une panne du traitement ferait disparaitre TOUTES les images au lieu
  # de retomber sur les originaux.
  def traitement_images_disponible?
    return @traitement_images if defined?(@traitement_images)

    @traitement_images = begin
      require "vips"
      true
    rescue LoadError, StandardError
      false
    end
  end

  def visuel_responsive(blob, largeurs:, sizes:, **options)
    return image_tag(blob, **options) unless traitement_images_disponible?
    return image_tag(blob, **options) unless blob.respond_to?(:variable?) && blob.variable?

    srcset = largeurs.map do |l|
      variante = blob.variant(resize_to_limit: [ l, nil ],
                              format: :webp, saver: { quality: 78 })
      "#{url_for(variante)} #{l}w"
    end.join(", ")

    # `src` = la plus petite : c'est le repli des navigateurs qui ignorent
    # `srcset`, et il ne doit pas etre le plus lourd.
    image_tag(blob.variant(resize_to_limit: [ largeurs.first, nil ],
                           format: :webp, saver: { quality: 78 }),
              srcset: srcset, sizes: sizes, **options)
  rescue StandardError
    # Un blob illisible ou non transformable ne doit jamais casser la page.
    image_tag(blob, **options)
  end

  # Vidéo du chien qui court (section contact) : dépose les fichiers sous
  # app/assets/images/dog-run.webm et .mp4 — sinon, bloc gris placeholder.
  def dog_video_available?
    %w[dog-run.webm dog-run.mp4].any? do |f|
      Rails.root.join("app/assets/images/#{f}").exist?
    end
  end

  # Images de survol de la page Travaux : dépose works-base/-cases/-gallery
  # (jpg ou png) — sinon, blocs gris distincts.
  def works_image(name)
    %w[jpg png webp].each do |ext|
      path = "works-#{name}.#{ext}"
      return path if Rails.root.join("app/assets/images/#{path}").exist?
    end
    nil
  end

  # --- /projets : format d'un bloc gris -------------------------------
  # Format d'un bloc gris de remplacement (tant qu'aucune image n'est
  # televersee). Volontairement varie : c'est ce qui rend l'ancrage visible.
  def csi_placeholder_ratio
    %w[3/4 1/1 4/3 16/10].sample
  end
end
