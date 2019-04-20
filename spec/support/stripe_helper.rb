MockStripeCard = Struct.new(
  :brand,
  :exp_month,
  :exp_year,
  :funding,
  :last4
)

MockStripePaymentMethodDetails = Struct.new(:type, :card)

MockStripeCharge = Struct.new(
  :id,
  :payment_method,
  :payment_method_details,
  :status
)

def mock_stripe_card
  MockStripeCard.new(
    'visa',
    '01',
    '2099',
    'credit',
    '4242'
  )
end

def mock_stripe_payment_method_details
  MockStripePaymentMethodDetails.new(
    'card',
    mock_stripe_card
  )
end

def mock_stripe_charge
  MockStripeCharge.new(
    'ch_1EQnncDGwZsAHsraJC1Tn0jy',
    'pm_1EQnncDGwZsAHsravlDKmuyR',
    mock_stripe_payment_method_details,
    'succeeded'
  )
end
