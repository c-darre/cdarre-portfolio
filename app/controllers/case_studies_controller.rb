class CaseStudiesController < ApplicationController
  def index
    # with_attached_hero_image : précharge attachments + blobs (évite le N+1).
    @case_studies = CaseStudy.published.ordered.with_attached_hero_image
  end

  def show
    # published.find_by!(slug:) : un brouillon n'existe pas pour le public → 404.
    # Route déclarée avec param: :slug → le paramètre s'appelle params[:slug].
    @case_study = CaseStudy.published.find_by!(slug: params[:slug])

    # Sections triées (scope de l'association) + rich text + images préchargés.
    @sections = @case_study.case_study_sections
                           .with_rich_text_body
                           .includes(images_attachments: :blob)

    # Navigation de bas de page : l'étude publiée suivante par position.
    @next_case_study = CaseStudy.published.where("position > ?", @case_study.position)
                                .ordered.first
  end
end
