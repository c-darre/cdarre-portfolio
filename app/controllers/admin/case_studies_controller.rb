module Admin
  class CaseStudiesController < BaseController
    before_action :set_case_study, only: %i[edit update destroy toggle_published]

    def index
      @case_studies = CaseStudy.ordered
    end

    def new
      @case_study = CaseStudy.new
    end

    def create
      @case_study = CaseStudy.new(case_study_params)
      if @case_study.save
        # Après création, on va vers l'édition : c'est là qu'on ajoute les sections.
        redirect_to edit_admin_case_study_path(@case_study),
                    notice: "Étude de cas créée. Ajoute maintenant ses sections."
      else
        render :new, status: :unprocessable_entity
      end
    end

    def edit; end

    def update
      if @case_study.update(case_study_params)
        redirect_to edit_admin_case_study_path(@case_study), notice: "Étude de cas mise à jour."
      else
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      @case_study.destroy
      redirect_to admin_case_studies_path, notice: "Étude de cas supprimée."
    end

    # Bascule publié/brouillon en un clic (bouton PATCH depuis l'index).
    def toggle_published
      @case_study.update(published: !@case_study.published)
      redirect_to admin_case_studies_path,
                  notice: @case_study.published? ? "Étude publiée." : "Étude repassée en brouillon."
    end

    # Réordonnancement : SortableJS envoie la liste ordonnée des ids, on écrit les positions.
    # N petites requêtes (update_all n'instancie pas les objets) : négligeable pour un portfolio.
    # Sur un gros volume, on ferait un seul UPDATE avec un CASE — inutile ici.
    def reorder
      params[:ids].each_with_index do |id, index|
        CaseStudy.where(id: id).update_all(position: index)
      end
      head :no_content
    end

    private

    # find_by! (et non find) car to_param renvoie le slug : params[:id] = "fibr".
    def set_case_study
      @case_study = CaseStudy.find_by!(slug: params[:id])
    end

    def case_study_params
      params.require(:case_study).permit(
        :title, :subtitle, :role, :context, :key_metric, :slug, :categories, :published, :hero_image
      )
    end
  end
end
