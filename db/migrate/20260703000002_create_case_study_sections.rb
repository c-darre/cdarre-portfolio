class CreateCaseStudySections < ActiveRecord::Migration[8.0]
  def change
    create_table :case_study_sections do |t|
      t.references :case_study, null: false, foreign_key: true
      t.string  :section_type, null: false    # enum string côté modèle
      t.string  :heading                      # titre optionnel de la section
      t.integer :position, null: false, default: 0
      t.timestamps
      # body   => ActionText (has_rich_text), table dédiée polymorphe
      # images => Active Storage (has_many_attached)
    end
    add_index :case_study_sections, [ :case_study_id, :position ]
    add_index :case_study_sections, [ :case_study_id, :section_type ]
  end
end
