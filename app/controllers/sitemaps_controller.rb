class SitemapsController < ApplicationController
  def show
    @case_studies = CaseStudy.published.ordered
  end
end
