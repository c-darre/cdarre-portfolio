class RemoveUnusedFromVisualWorks < ActiveRecord::Migration[8.1]
  def change
    # Le feed ne classe plus, ne trie plus et n'affiche plus de fiche : ces
    # colonnes n'ont plus d'emploi. Les index qui les portent tombent avec.
    remove_index  :visual_works, :category, if_exists: true
    remove_index  :visual_works, :position, if_exists: true

    remove_column :visual_works, :category,    :string
    remove_column :visual_works, :tools,       :string
    remove_column :visual_works, :description, :text
    remove_column :visual_works, :position,    :integer, default: 0, null: false
  end
end
