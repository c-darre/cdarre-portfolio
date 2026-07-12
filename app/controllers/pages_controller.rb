class PagesController < ApplicationController
  def home
    # Toutes les études publiées : le portfolio est prévu pour grandir.
    @case_studies = CaseStudy.published.ordered.with_attached_hero_image
  end

  def about; end
  def contact; end
end
