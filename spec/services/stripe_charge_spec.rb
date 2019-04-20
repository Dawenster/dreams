require 'rails_helper'

RSpec.describe StripeCharge do
  let(:user) { Fabricate(:user) }
  let(:dream) { Fabricate(:dream, user: user) }
  let(:buyer) { Fabricate(:user) }
  let(:amount_in_cents) { 1000 }
  let(:fee_in_cents) { 100 }

  before do
    @sc = StripeCharge.new(
      amount_in_cents,
      fee_in_cents,
      'stripe_token',
      dream,
      buyer
    )
  end

  describe '#create_payment_method' do
    it 'creates a new payment method' do
      expect do
        pm = @sc.create_payment_method(mock_stripe_charge)

        expect(pm.brand).to eq('visa')
        expect(pm.exp_month).to eq('01')
        expect(pm.exp_year).to eq('2099')
        expect(pm.funding).to eq('credit')
        expect(pm.last4).to eq('4242')
        expect(pm.status).to eq('succeeded')
        expect(pm.payment_method_type).to eq('card')
        expect(pm.stripe_payment_method_id)
          .to eq(mock_stripe_charge.payment_method)
        expect(pm.user).to eq(buyer)
      end.to change(PaymentMethod, :count).from(0).to(1)
    end

    it 'updates an existing payment method' do
      Fabricate(
        :payment_method,
        stripe_payment_method_id: mock_stripe_charge.payment_method,
        user: buyer,
        last4: '1234'
      )

      expect do
        pm = @sc.create_payment_method(mock_stripe_charge)

        expect(pm.brand).to eq('visa')
        expect(pm.exp_month).to eq('01')
        expect(pm.exp_year).to eq('2099')
        expect(pm.funding).to eq('credit')
        expect(pm.last4).to eq('4242')
        expect(pm.status).to eq('succeeded')
        expect(pm.payment_method_type).to eq('card')
        expect(pm.stripe_payment_method_id)
          .to eq(mock_stripe_charge.payment_method)
        expect(pm.user).to eq(buyer)
      end.to change(PaymentMethod, :count).by(0)
    end
  end

  describe '#create_charge' do
    let(:pm) {
      Fabricate(
        :payment_method,
        stripe_payment_method_id: mock_stripe_charge.payment_method,
        user: buyer,
        last4: '1234'
      )
    }

    it 'creates a new charge' do
      expect do
        charge = @sc.create_charge(mock_stripe_charge, pm)

        expect(charge.amount_in_cents).to eq(amount_in_cents)
        expect(charge.fee_in_cents).to eq(fee_in_cents)
        expect(charge.currency).to eq('usd')
        expect(charge.stripe_charge_id).to eq(mock_stripe_charge.id)
        expect(charge.payment_method).to eq(pm)
        expect(charge.user).to eq(buyer)
      end.to change(Charge, :count).from(0).to(1)
    end
  end

  describe '#run!' do
    it 'hits Stripe and creates correct records' do
      allow(Stripe::Charge).to receive(:create).and_return(mock_stripe_charge)
      expect(Stripe::Charge).to receive(:create).with({
        amount: amount_in_cents + fee_in_cents,
        currency: 'usd',
        source: 'stripe_token',
        description: "For dream: #{dream.id}"
      })

      expect do
        @sc.run!
      end.to change(Charge, :count).from(0).to(1)
         .and change(PaymentMethod, :count).from(0).to(1)
    end
  end
end
