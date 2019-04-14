class CreateElements < ActiveRecord::Migration[5.2]
  def change
    create_table(:elements, id: :uuid) do |t|
      t.string :name, null: false
      t.string :dimension, null: false
      t.text :commentary, null: false
      t.string :image_url

      t.timestamps
    end
  end
end
