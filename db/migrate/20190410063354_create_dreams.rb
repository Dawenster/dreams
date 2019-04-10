class CreateDreams < ActiveRecord::Migration[5.2]
  def change
    create_table(:dreams, id: :uuid) do |t|
      t.string :title

      t.references(
        :user,
        type: :uuid,
        index: true,
        foreign_key: true,
        null: false
      )

      t.timestamps
    end
  end
end
