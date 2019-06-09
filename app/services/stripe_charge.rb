class StripeCharge
  def initialize(amount_in_cents, fee_in_cents, stripe_token, dream, buyer)
    @amount_in_cents = amount_in_cents
    @fee_in_cents = fee_in_cents
    @stripe_token = stripe_token # obtained with Stripe.js
    @currency = 'usd'
    @dream = dream
    @buyer = buyer
  end

  def run!
    stripe_charge = Stripe::Charge.create({
      amount: @amount_in_cents,
      currency: @currency,
      source: @stripe_token,
      description: "For dream: #{@dream.id}"
    })

    payment_method = create_payment_method(stripe_charge)
    create_charge(stripe_charge, payment_method)
  end

  def create_payment_method(stripe_charge)
    payment_method = PaymentMethod.find_or_initialize_by(
      stripe_payment_method_id: stripe_charge.payment_method
    )

    payment_method_details = stripe_charge.payment_method_details

    payment_method.payment_method_type = payment_method_details.type
    payment_method.status = stripe_charge.status
    payment_method.user = @buyer

    if payment_method.payment_method_type == 'card'
      card = payment_method_details.card

      payment_method.brand = card.brand
      payment_method.exp_month = card.exp_month
      payment_method.exp_year = card.exp_year
      payment_method.funding = card.funding
      payment_method.last4 = card.last4
    end

    payment_method.save!
    payment_method
  end

  def create_charge(stripe_charge, payment_method)
    Charge.create(
      amount_in_cents: @amount_in_cents,
      fee_in_cents: @fee_in_cents,
      currency: @currency,
      stripe_charge_id: stripe_charge.id,
      payment_method: payment_method,
      user: @buyer
    )
  end
end
