module Admin
  class VisualWorksController < BaseController
    before_action :set_visual_work, only: %i[edit update destroy toggle_published]

    def index
      @visual_works = VisualWork.ordered
    end

    def new
      @visual_work = VisualWork.new
    end

    def create
      @visual_work = VisualWork.new(visual_work_params)
      if @visual_work.save
        redirect_to admin_visual_works_path, notice: "Création ajoutée."
      else
        render :new, status: :unprocessable_entity
      end
    end

    def edit; end

    def update
      if @visual_work.update(visual_work_params)
        redirect_to admin_visual_works_path, notice: "Création mise à jour."
      else
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      @visual_work.destroy
      redirect_to admin_visual_works_path, notice: "Création supprimée."
    end

    def toggle_published
      @visual_work.update(published: !@visual_work.published)
      redirect_to admin_visual_works_path
    end

    def reorder
      params[:ids].each_with_index do |id, index|
        VisualWork.where(id: id).update_all(position: index)
      end
      head :no_content
    end

    private

    def set_visual_work
      @visual_work = VisualWork.find(params[:id])
    end

    def visual_work_params
      params.require(:visual_work).permit(:title, :category, :description, :published, images: [])
    end
  end
end
