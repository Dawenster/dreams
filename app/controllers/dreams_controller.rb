class DreamsController < ApplicationController
  def show
    @dream = Dream.find(params[:id])

    render json: DreamSerializer.new(@dream).serialized_json, status: :ok
  end

  def random
    @dream = Dream.all.sample

    render json: DreamSerializer.new(@dream).serialized_json, status: :ok
  end
end
