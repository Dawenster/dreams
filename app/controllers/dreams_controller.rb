class DreamsController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:create]

  def show
    @dream = Dream.find(params[:id])

    render(
      json: serialized_dream_json(@dream),
      status: :ok
    )
  rescue => e
    log_and_return_error(e)
  end

  def random
    @dream = Dream.all.sample

    render(
      json: serialized_dream_json(@dream),
      status: :ok
    )
  rescue => e
    log_and_return_error(e)
  end

  def create
    @dream = Dream.new(dream_params)
    email = params[:email].try(:strip).try(:downcase)
    user = User.find_or_create_by!(email: email)
    element_ids = params[:element_ids].try(:split, ',').try(:compact).try(:uniq)
    elements = Element.where(id: element_ids)

    @dream.user = user

    if @dream.save && elements.any?
      @dream.elements << elements

      render(
        json: serialized_dream_json(@dream),
        status: :ok
      )
    else
      messages = @dream.errors.full_messages
      messages << 'missing at least one symbol ID' if elements.empty?

      error = { message: capitalize_first(messages.to_sentence) }

      render json: error, status: :bad_request
    end
  rescue => e
    log_and_return_error(e)
  end

  private

  def dream_params
    params.permit(:title, :description)
  end

  def capitalize_first(string)
    string.slice(0, 1).capitalize + string.slice(1..-1)
  end

  def serialized_dream_json(dream)
    options = { include: [:user, :elements] }
    DreamSerializer.new(dream, options).serialized_json
  end
end
