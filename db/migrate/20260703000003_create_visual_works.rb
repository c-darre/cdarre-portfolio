class CreateVisualWorks < ActiveRecord::Migration[8.0]
  def change
    create_table :visual_works do |t|
      t.string  :title,     null: false
      t.string  :category                     # enum string côté modèle
      t.text    :description
      t.integer :position,  null: false, default: 0
      t.boolean :published, null: false, default: false
      t.timestamps
    end
    add_index :visual_works, :position
    add_index :visual_works, :published
    add_index :visual_works, :category
  end
end
