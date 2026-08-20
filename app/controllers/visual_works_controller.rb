class VisualWorksController < ApplicationController
  def index
    # Feed : pele-mele, sans categorie ni filtre. L'ordre change a chaque
    # visite (voir le scope `feed` du modele).
    @visual_works = VisualWork.published.feed.with_attached_images
  end

end
