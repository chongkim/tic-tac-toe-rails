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
      sleep(2)
    end
    render :json => clj.random_best_move(position)
  end
end
