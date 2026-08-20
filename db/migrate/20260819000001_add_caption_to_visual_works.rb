class AddCaptionToVisualWorks < ActiveRecord::Migration[8.1]
  def change
    # Legende facultative : un visuel peut vivre seul.
    add_column :visual_works, :caption, :text

    # Le titre devient facultatif : dans un feed, il ne sert plus qu'a
    # identifier la piece au back-office et a renseigner l'attribut alt.
    change_column_null :visual_works, :title, true
  end
end
