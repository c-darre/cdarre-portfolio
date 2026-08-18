module MediaHelper
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
