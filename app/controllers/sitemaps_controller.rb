class SitemapsController < ApplicationController
  def show
    @case_studies = CaseStudy.published.ordered
    @visual_works = VisualWork.published.ordered
  end
end
