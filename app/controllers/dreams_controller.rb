class DreamsController < ApplicationController
  def random
    @dream = Dream.all.sample

    render json: @dream, status: :ok
  end
end
