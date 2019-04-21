require 'rails_helper'

RSpec.describe Charge, type: :model do
  describe '#total_charged_in_cents' do
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
      expect(charge.total_charged_in_cents).to eq(600)
    end
  end
end
