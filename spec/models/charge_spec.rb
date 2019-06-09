# == Schema Information
#
# Table name: charges
#
#  id                :uuid             not null, primary key
#  amount_in_cents   :integer          not null
#  currency          :string           not null
#  fee_in_cents      :integer          not null
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  payment_method_id :uuid             not null
#  stripe_charge_id  :string           not null
#  user_id           :uuid             not null
#
# Indexes
#
#  index_charges_on_payment_method_id  (payment_method_id)
#  index_charges_on_user_id            (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (payment_method_id => payment_methods.id)
#  fk_rails_...  (user_id => users.id)
#

require 'rails_helper'

RSpec.describe Charge, type: :model do
  describe '#amount_to_donate_in_cents' do
    let(:user) { Fabricate(:user) }
    let(:payment_method) {
      Fabricate(
        :payment_method,
        user: user,
        stripe_payment_method_id: 'foo'
      )
    }
    let(:charge) {
      Fabricate(
        :charge,
        amount_in_cents: 500,
        fee_in_cents: 100,
        user: user,
        payment_method: payment_method,
        stripe_charge_id: 'bar'
      )
    }

    it 'returns sum of amount and fee' do
      expect(charge.amount_to_donate_in_cents).to eq(400)
    end
  end
end
