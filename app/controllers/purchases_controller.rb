class InvalidAmountError < StandardError
  def initialize(param)
    @param = param
  end

  def code
    400
  end

  def message
    "#{@param} is below the minimum required amount"
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
      :stripe_token
    ])

    amount_in_cents = params[:amount_in_cents].to_i
    fee_in_cents = params[:fee_in_cents].to_i

    raise InvalidAmountError.new(:amount_in_cents) if amount_in_cents < 500

    fee_in_cents = calculate_fees(amount_in_cents)
    recipient = find_or_create_user_by_email(params[:recipient_email], params[:recipient_name])
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

    ActiveRecord::Base.transaction do
      charge = sc.run!

      @purchase.charge = charge
      @purchase.save!
    end

    unless Rails.env.test?
      send_buyer_email
      send_recipient_email
    end

    head :ok
  rescue => e
    log_and_return_error(e)
  end

  private

  def calculate_fees(amount_in_cents)
    amount_in_cents / 10
  end

  def purchase_params
    params.permit(:message)
  end

  def find_or_create_user_by_email(email, name = nil)
    email = email.try(:strip).try(:downcase)
    user = User.find_or_initialize_by(email: email)

    user.name = name.blank? ? nil : name
    user.save!

    user
  end

  def send_buyer_email
    POSTMARK.deliver_with_template(
      from: SEND_DREAMS_EMAIL_SENDER,
      to: @purchase.buyer.email,
      template_id: POSTMARK_DREAM_PURCHASED_BUYER_TEMPLATE_ID,
      template_model: buyer_template_model
    )
  end

  def send_recipient_email
    POSTMARK.deliver_with_template(
      from: SEND_DREAMS_EMAIL_SENDER,
      to: @purchase.recipient.email,
      template_id: POSTMARK_DREAM_PURCHASED_RECIPIENT_TEMPLATE_ID,
      template_model: recipient_template_model
    )
  end

  def buyer_template_model
    recipient = @purchase.recipient
    charge = @purchase.charge
    payment_method = charge.payment_method
    amount = charge.amount_in_cents - charge.fee_in_cents

    {
      recipient_email: recipient.email,
      recipient_name: recipient.name || recipient.email,
      buyer_email: @purchase.buyer.email,
      credit_card_brand: payment_method.brand,
      credit_card_last_four: payment_method.last4,
      purchase_id: @purchase.id[0..7],
      purchase_date: @purchase.created_at.strftime('%b %d, %Y'),
      purchase_amount_in_dollars: cents_to_dollars(amount),
      purchase_fee_in_dollars: cents_to_dollars(charge.fee_in_cents),
      purchase_total_in_dollars: cents_to_dollars(charge.amount_in_cents)
    }
  end

  def recipient_template_model
    recipient = @purchase.recipient

    {
      recipient_name: recipient.name || recipient.email,
      buyer_email: @purchase.buyer.email,
      dream_description: @purchase.dream.description,
      message: @purchase.message,
      purchase_date: @purchase.created_at
    }
  end

  def cents_to_dollars(cents)
    '%.2f' % (cents.to_i / 100.0)
  end
end
