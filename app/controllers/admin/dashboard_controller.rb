module Admin
  class DashboardController < BaseController
    def index
      @case_studies = CaseStudy.ordered
      @visual_works = VisualWork.order(created_at: :desc)
      @awards       = Award.order(:position)
    end
  end
end
