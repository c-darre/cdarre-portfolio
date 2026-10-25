class PagesController < ApplicationController
  CV_PATH = Rails.root.join("lib/documents/cv-cyprien-darre.pdf").freeze

  def home
    @case_studies = CaseStudy.published.ordered.with_attached_hero_image
    # Mise en avant : 5 visuels tires au sort a chaque affichage de la home.
    # L'ordre aleatoire est demande a la base (ORDER BY RANDOM()) plutot que
    # de tout charger pour n'en garder que cinq.
    @visual_works = VisualWork.published.with_attached_images
                              .order(Arel.sql("RANDOM()")).limit(5)
  end

  def works; end   # écran de choix Case studies / Galerie

  def about; end
  def contact; end

  def legal;   end
  def privacy; end
  def faq;     end

  # Le PDF vit hors de public/ pour echapper au cache long, et le navigateur
  # doit revalider a chaque visite : un CV se remplace souvent.
  def cv
    return head :not_found unless File.exist?(CV_PATH)

    response.headers["Cache-Control"] = "no-cache, must-revalidate"
    send_file CV_PATH, type: "application/pdf", disposition: "inline",
              filename: "CV-Cyprien-Darre.pdf"
  end
end
