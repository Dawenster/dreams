class CreatePaymentMethods < ActiveRecord::Migration[5.2]
  def change
    create_table :payment_methods, id: :uuid do |t|
      t.string :type, null: false
      t.string :stripe_payment_method_id, null: false
      t.string :brand, null: false
      t.string :funding, null: false
      t.string :last4, null: false
      t.string :exp_month, null: false
      t.string :exp_year, null: false
      t.string :status, null: false

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
