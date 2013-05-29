class TttController < ApplicationController
  def index
  end

  def move
    core = JRClj.new
    render :json => core.move(params[:board], params[:turn])
  end
end
