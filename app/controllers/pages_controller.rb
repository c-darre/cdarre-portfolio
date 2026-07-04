class PagesController < ApplicationController
  def home
    @case_studies = CaseStudy.published.ordered.limit(3)  # jamais de brouillon en public
    @award        = Award.published.order(:position).first
  end

  def about; end
  def contact; end
end
