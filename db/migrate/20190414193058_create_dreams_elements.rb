class CreateDreamsElements < ActiveRecord::Migration[5.2]
  def change
    create_table :dreams_elements do |t|
      t.references(
        :dream,
        type: :uuid,
        index: true,
        foreign_key: true,
        null: false
      )

      t.references(
        :element,
        type: :uuid,
        index: true,
        foreign_key: true,
        null: false
      )
    end
  end
end
