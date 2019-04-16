class ElementsController < ApplicationController
  def index
    @elements = Element.all

    render json: ElementSerializer.new(@elements).serialized_json, status: :ok
  rescue => e
    log_and_return_error(e)
  end
end
