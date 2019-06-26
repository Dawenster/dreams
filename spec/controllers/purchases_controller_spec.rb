require 'rails_helper'

RSpec.describe PurchasesController, type: :controller do
  let(:user) { Fabricate(:user) }
  let(:dream) { Fabricate(:dream, user: user) }

  describe '#create' do
    before do
      allow(Stripe::Charge).to receive(:create).and_return(mock_stripe_charge)
    end

    it 'succeeds with all required params' do
      params = {
        recipient_email: 'recipient@foo.com',
        recipient_name: 'recipient',
        buyer_email: 'buyer@foo.com',
        buyer_name: 'buyer',
        dream_id: dream.id,
        amount_in_cents: '500',
        stripe_token: 'stripe_token',
        message: 'foo foo foo'
      }

      res = nil

      expect do
        res = post(:create, params: params)
      end.to change(Purchase, :count).by(1)
         .and change(User, :count).by(2)

      expect(res.body).to eq('')
      expect(res.status).to eq(200)

      purchase = Purchase.first

      expect(purchase.recipient.email).to eq('recipient@foo.com')
      expect(purchase.buyer.email).to eq('buyer@foo.com')
      expect(purchase.dream.id).to eq(dream.id)
      expect(purchase.message).to eq('foo foo foo')
      expect(purchase.charge.amount_to_donate_in_cents).to eq(450)
    end

    it 'succeeds without creating new users' do
      Fabricate(:user, email: 'recipient@foo.com')
      Fabricate(:user, email: 'buyer@foo.com')

      params = {
        recipient_email: 'recipient@foo.com',
        recipient_name: 'recipient',
        buyer_email: 'buyer@foo.com',
        buyer_name: 'buyer',
        dream_id: dream.id,
        amount_in_cents: '500',
        stripe_token: 'stripe_token',
        message: 'foo foo foo'
      }

      res = nil

      expect do
        res = post(:create, params: params)
      end.to change(Purchase, :count).by(1)
         .and change(User, :count).by(0)
    end

    it 'fails with missing parameters' do
      params = {}

      res = post(:create, params: params)
      body = JSON.parse(res.body)
      error = body.fetch('error')

      error_message = 'Need to pass in recipient_email, recipient_name, ' \
                      'buyer_email, buyer_name, dream_id, amount_in_cents, ' \
                      'and stripe_token as parameters'

      expect(error.include?(error_message)).to eq(true)
      expect(res.code).to eq('400')
    end

    it 'fails with negative amount_in_cents' do
      params = {
        recipient_email: 'recipient@foo.com',
        recipient_name: 'recipient',
        buyer_email: 'buyer@foo.com',
        buyer_name: 'buyer',
        dream_id: dream.id,
        amount_in_cents: '-500',
        stripe_token: 'stripe_token',
        message: 'foo foo foo'
      }

      res = post(:create, params: params)
      body = JSON.parse(res.body)
      error = body.fetch('error')

      error_message = 'amount_in_cents is below the minimum required amount'

      expect(error.include?(error_message)).to eq(true)
      expect(res.code).to eq('400')
    end

    it 'fails with amount_in_cents less than 500' do
      params = {
        recipient_email: 'recipient@foo.com',
        recipient_name: 'recipient',
        buyer_email: 'buyer@foo.com',
        buyer_name: 'buyer',
        dream_id: dream.id,
        amount_in_cents: '499',
        stripe_token: 'stripe_token',
        message: 'foo foo foo'
      }

      res = post(:create, params: params)
      body = JSON.parse(res.body)
      error = body.fetch('error')

      error_message = 'amount_in_cents is below the minimum required amount'

      expect(error.include?(error_message)).to eq(true)
      expect(res.code).to eq('400')
    end
  end
end
