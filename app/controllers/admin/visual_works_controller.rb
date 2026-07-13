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
        attach_new_images(@visual_work)
        redirect_to admin_visual_works_path, notice: "Création ajoutée."
      else
        render :new, status: :unprocessable_entity
      end
    end

    def edit; end

    def update
      if @visual_work.update(visual_work_params)
        purge_selected_images(@visual_work)
        attach_new_images(@visual_work)
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

    def attach_new_images(work)
      files = Array(params.dig(:visual_work, :images)).reject(&:blank?)
      work.images.attach(files) if files.any?
    end

    def purge_selected_images(work)
      ids = Array(params.dig(:visual_work, :purge_image_ids)).reject(&:blank?)
      work.images.where(id: ids).each(&:purge) if ids.any?
    end

    def visual_work_params
      params.require(:visual_work).permit(:title, :category, :description, :tools, :published)
    end
  end
end
