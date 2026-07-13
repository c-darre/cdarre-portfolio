class AddToolsToVisualWorks < ActiveRecord::Migration[8.0]
  def change
    # Outils/compétences affichés sur la card (saisie libre, virgules, max 4).
    add_column :visual_works, :tools, :string
  end
end
