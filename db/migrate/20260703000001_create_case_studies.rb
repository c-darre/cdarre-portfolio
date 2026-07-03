class CreateCaseStudies < ActiveRecord::Migration[8.0]
  def change
    create_table :case_studies do |t|
      t.string  :title,     null: false
      t.string  :subtitle
      t.string  :role                          # ex. "Lead UX/UI + UX Writing"
      t.text    :context                       # résumé de contexte (bloc Hero)
      t.string  :key_metric                    # 1 métrique clé affichée dans le Hero
      t.string  :slug,      null: false
      t.integer :position,  null: false, default: 0
      t.boolean :published, null: false, default: false
      t.timestamps
    end
    add_index :case_studies, :slug, unique: true
    add_index :case_studies, :position
    add_index :case_studies, :published
  end
end
