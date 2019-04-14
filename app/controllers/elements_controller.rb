class ElementsController < ApplicationController
  def index
    @elements = Element.all

    render json: ElementSerializer.new(@elements).serialized_json, status: :ok
  end
end
