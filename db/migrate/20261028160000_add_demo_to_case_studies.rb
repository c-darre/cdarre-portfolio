class AddDemoToCaseStudies < ActiveRecord::Migration[8.1]
  # Lien vers la demo en ligne d'une etude, avec sa note d'usage. Les deux
  # restent vides sur les etudes qui n'ont rien a montrer : le bloc ne
  # s'affiche alors pas du tout.
  def change
    add_column :case_studies, :demo_url,  :string
    add_column :case_studies, :demo_note, :text
  end
end
