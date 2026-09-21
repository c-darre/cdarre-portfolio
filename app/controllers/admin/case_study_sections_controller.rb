module Admin
  class CaseStudySectionsController < BaseController
    before_action :set_case_study, only: %i[new create reorder]
    before_action :set_section,    only: %i[edit update destroy]

    def new
      @section = @case_study.case_study_sections.build(position: next_position)
    end

    def create
      @section = @case_study.case_study_sections.build(section_params)
      if @section.save
        attach_new_images(@section)   # images attachées après save (record persisté)
        redirect_to edit_admin_case_study_path(@case_study), notice: "Section ajoutée."
      else
        render :new, status: :unprocessable_entity
      end
    end

    def edit; end

    def update
      if @section.update(section_params)
        purge_selected_images(@section)   # retire celles cochées « supprimer »
        save_captions(@section)           # légendes des images déjà attachées
        attach_new_images(@section)       # ajoute les nouvelles (sans écraser les autres)
        redirect_to edit_admin_case_study_path(@section.case_study), notice: "Section mise à jour."
      else
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      case_study = @section.case_study
      @section.destroy
      redirect_to edit_admin_case_study_path(case_study), notice: "Section supprimée."
    end

    def reorder
      params[:ids].each_with_index do |id, index|
        @case_study.case_study_sections.where(id: id).update_all(position: index)
      end
      head :no_content
    end

    private

    # Route imbriquée → params[:case_study_id] = slug de l'étude parente.
    def set_case_study
      @case_study = CaseStudy.find_by!(slug: params[:case_study_id])
    end

    # Route shallow → la section se trouve par son propre id.
    def set_section
      @section = CaseStudySection.find(params[:id])
    end

    def next_position
      (@case_study.case_study_sections.maximum(:position) || -1) + 1
    end

    def attach_new_images(section)
      files = Array(params.dig(:case_study_section, :images)).reject(&:blank?)
      section.images.attach(files) if files.any?
    end

    def purge_selected_images(section)
      ids = Array(params.dig(:case_study_section, :purge_image_ids)).reject(&:blank?)
      section.images.where(id: ids).each(&:purge) if ids.any?  # purge synchrone : ok à cette échelle
    end

    # La legende vit dans les metadonnees du blob. On FUSIONNE au lieu de
    # remplacer : ecraser la cle `analyzed` relancerait l'analyse d'Active
    # Storage, qui recalculerait les dimensions a chaque enregistrement.
    def save_captions(section)
      legendes = params.dig(:case_study_section, :captions)
      return if legendes.blank?

      legendes.each do |id, texte|
        blob = section.images.find_by(id: id)&.blob
        next if blob.nil?

        blob.update(metadata: blob.metadata.merge("caption" => texte.to_s.strip.presence))
      end
    end

    # Images gérées séparément → volontairement HORS des params d'assignation.
    def section_params
      params.require(:case_study_section).permit(:section_type, :heading, :body)
    end
  end
end
