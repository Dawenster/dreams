class RemoveTitleFromDreams < ActiveRecord::Migration[5.2]
  def change
    remove_column :dreams, :title
    change_column :dreams, :description, :text, null: false
  end
end
