class AddDescriptionAndShowDescriptionToDreams < ActiveRecord::Migration[5.2]
  def change
    add_column :dreams, :description, :text
    add_column :dreams, :show_description, :boolean, default: false
  end
end
