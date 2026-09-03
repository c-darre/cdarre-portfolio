class AddSpamToContactMessages < ActiveRecord::Migration[8.1]
  def change
    add_column :contact_messages, :spam, :boolean, default: false, null: false
    add_index :contact_messages, :spam
  end
end
