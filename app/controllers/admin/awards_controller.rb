module Admin
  class AwardsController < BaseController
    before_action :set_award, only: %i[edit update destroy]

    def index
      @awards = Award.order(:position)
    end

    def new
      @award = Award.new
    end

    def create
      @award = Award.new(award_params)
      if @award.save
        redirect_to admin_awards_path, notice: "Récompense ajoutée."
      else
        render :new, status: :unprocessable_entity
      end
    end

    def edit; end

    def update
      if @award.update(award_params)
        redirect_to admin_awards_path, notice: "Récompense mise à jour."
      else
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      @award.destroy
      redirect_to admin_awards_path, notice: "Récompense supprimée."
    end

    private

    def set_award
      @award = Award.find(params[:id])
    end

    def award_params
      params.require(:award).permit(:title, :year, :description, :published, :badge)
    end
  end
end
