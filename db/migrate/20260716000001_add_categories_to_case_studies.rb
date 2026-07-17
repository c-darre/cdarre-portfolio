class AddCategoriesToCaseStudies < ActiveRecord::Migration[8.0]
  def change
    # Catégories multiples par étude (tags séparés par virgules, parsés côté modèle).
    add_column :case_studies, :categories, :string
  end
end
