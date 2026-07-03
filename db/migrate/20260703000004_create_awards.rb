class CreateAwards < ActiveRecord::Migration[8.0]
  def change
    create_table :awards do |t|
      t.string  :title,     null: false
      t.integer :year
      t.text    :description
      t.integer :position,  null: false, default: 0
      t.boolean :published, null: false, default: true
      t.timestamps
    end
  end
end
