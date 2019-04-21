class InvalidAmountError < StandardError
  def initialize(param)
    @param = param
  end

  def code
    400
  end

  def message
    "#{@param} is not a positive integer"
  end
end

class PurchasesController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:create]

  def create
    required_parameters([
      :recipient_email,
      :buyer_email,
      :dream_id,
      :amount_in_cents,
      :fee_in_cents,
      :stripe_token
    ])

    amount_in_cents = params[:amount_in_cents].to_i
    fee_in_cents = params[:fee_in_cents].to_i

    raise InvalidAmountError.new(:amount_in_cents) if amount_in_cents <= 0
    raise InvalidAmountError.new(:fee_in_cents) if fee_in_cents <= 0

    recipient = find_or_create_user_by_email(params[:recipient_email])
    buyer = find_or_create_user_by_email(params[:buyer_email])
    dream = Dream.find(params[:dream_id])

    @purchase = Purchase.new(purchase_params)
    @purchase.recipient = recipient
    @purchase.buyer = buyer
    @purchase.dream = dream

    sc = StripeCharge.new(
      amount_in_cents,
      fee_in_cents,
      params[:stripe_token],
      dream,
      buyer
    )

    charge = sc.run!

    @purchase.charge = charge
    @purchase.save!

    head :ok
  rescue => e
    log_and_return_error(e)
  end

  private

  def purchase_params
    params.permit(:message)
  end

  def find_or_create_user_by_email(email)
    email = email.try(:strip).try(:downcase)
    User.find_or_create_by!(email: email)
  end
end
