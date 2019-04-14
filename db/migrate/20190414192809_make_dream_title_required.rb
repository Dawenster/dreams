class MakeDreamTitleRequired < ActiveRecord::Migration[5.2]
  def change
    change_column :dreams, :title, :string, null: false
  end
end
