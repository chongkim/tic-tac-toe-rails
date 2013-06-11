class TttController < ApplicationController
  def index
  end

  def move
    clj = JRClj.new("ttt.core")
    board = clj.vec(params[:board].map { |cell| clj.symbol(cell) })
    turn = clj.symbol(params[:turn])
    position = clj.init_position(board, turn)
    speed = params[:speed]
    if (speed == "slow_option") then
      timeout = params[:board].count("-") - 4
      sleep(timeout) if 0 < timeout
    end
    render :json => clj.random_best_move(position)
  end
end
