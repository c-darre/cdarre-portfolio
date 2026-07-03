module Admin
  class DashboardController < BaseController
    def index
      @case_studies = CaseStudy.ordered
      @visual_works = VisualWork.ordered
      @awards       = Award.order(:position)
    end
  end
end
