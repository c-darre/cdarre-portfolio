class PagesController < ApplicationController
  def home
    @case_studies = CaseStudy.published.ordered.with_attached_hero_image
    @visual_works = VisualWork.published.ordered.with_attached_images
  end

  def works; end   # écran de choix Study cases / Galerie

  def about; end
  def contact; end
end
