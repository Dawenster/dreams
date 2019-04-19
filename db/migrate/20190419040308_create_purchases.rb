class CreatePurchases < ActiveRecord::Migration[5.2]
  def change
    create_table :purchases, id: :uuid do |t|
      t.text :message

      t.references(
        :recipient,
        type: :uuid,
        index: true,
        foreign_key: { to_table: :users },
        null: false
      )

      t.references(
        :buyer,
        type: :uuid,
        index: true,
        foreign_key: { to_table: :users },
        null: false
      )

      t.references(
        :dream,
        type: :uuid,
        index: true,
        foreign_key: true,
        null: false
      )

      t.references(
        :charge,
        type: :uuid,
        index: true,
        foreign_key: true,
        null: false
      )

      t.timestamps
    end
  end
end
