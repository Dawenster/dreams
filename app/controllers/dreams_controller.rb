class DreamsController < ApplicationController
  def random
    @dream = Dream.all.sample

    render json: DreamSerializer.new(@dream).serialized_json, status: :ok
  end
end
