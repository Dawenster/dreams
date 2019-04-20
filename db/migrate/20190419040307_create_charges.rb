class CreateCharges < ActiveRecord::Migration[5.2]
  def change
    create_table :charges, id: :uuid do |t|
      t.integer :amount_in_cents, null: false
      t.integer :fee_in_cents, null: false
      t.string :stripe_charge_id, null: false
      t.string :currency, null: false

      t.references(
        :user,
        type: :uuid,
        index: true,
        foreign_key: true,
        null: false
      )

      t.references(
        :payment_method,
        type: :uuid,
        index: true,
        foreign_key: true,
        null: false
      )

      t.timestamps
    end
  end
end
