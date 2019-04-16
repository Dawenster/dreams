class ChangeShowDescriptionToPublishedOnDreams < ActiveRecord::Migration[5.2]
  def change
    rename_column :dreams, :show_description, :published
  end
end
