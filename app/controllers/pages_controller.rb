class PagesController < ApplicationController
  def home
    @case_studies = CaseStudy.published.ordered.with_attached_hero_image
    # Mise en avant : 5 visuels tires au sort a chaque affichage de la home.
    # L'ordre aleatoire est demande a la base (ORDER BY RANDOM()) plutot que
    # de tout charger pour n'en garder que cinq.
    @visual_works = VisualWork.published.with_attached_images
                              .order(Arel.sql("RANDOM()")).limit(5)
  end

  def works; end   # écran de choix Study cases / Galerie

  def about; end
  def contact; end
end
