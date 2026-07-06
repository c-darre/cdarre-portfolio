class VisualWorksController < ApplicationController
  def index
    scope = VisualWork.published.ordered.with_attached_images

    # Catégories réellement présentes (publiées), dans l'ordre de l'enum.
    @categories = VisualWork.categories.values &
                  VisualWork.published.distinct.pluck(:category).compact

    # Filtre par lien (?categorie=identite) — validé contre l'enum, sinon ignoré.
    @current_category = params[:categorie].presence
    @current_category = nil unless VisualWork.categories.value?(@current_category)
    scope = scope.where(category: @current_category) if @current_category

    @visual_works = scope
  end

  def show
    @visual_work = VisualWork.published.with_attached_images.find(params[:id])
  end
end
