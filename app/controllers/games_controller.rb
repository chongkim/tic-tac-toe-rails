class GamesController < ApplicationController
  include ApplicationHelper

  # GET /games
  # GET /games.json
  def index
    @games = Game.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @games }
    end
  end

  # GET /games/1
  # GET /games/1.json
  def show
    if current_user.nil?
      session[:original_path] = request.original_fullpath
      query_params = {}
      query_params.merge!(:login_token => params[:login_token]) if !params[:login_token].nil?
      redirect_to params[:login_token] ? edit_user_path(query_params) : sign_in_path(query_params)
      return
    end

    @game = Game.find(params[:id])
    @first_player = @game.first_user || User.new
    @second_player = @game.second_user || User.new
    @current_player = current_user || User.new
    @current_player_symbol = current_user.id == @game.first_user.id ? "x" : "o"
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @game }
    end
  end

  # GET /games/new
  # GET /games/new.json
  def new
    @game = Game.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @game }
    end
  end

  # GET /games/1/edit
  def edit
    @game = Game.find(params[:id])
  end

  # POST /games
  # POST /games.json
  def create
    # make sure user is signed in
    if !user_signed_in?
      flash[:error] = "You need to log in first"
      redirect_to new_game_path
      return
    end
    # make sure email address is filled in
    if params[:email].empty?
      flash[:error] = "You need to specify an email address"
      redirect_to new_game_path
      return
    end
    opponent = User.find_or_create_by_email(params[:email])
    game = Game.new
    game.turn = "x"
    if params[:i_play_first]
      game.first_user_id = current_user.id
      game.second_user_id = opponent.id
    else
      game.first_user_id = opponent.id
      game.second_user_id = current_user.id
    end
    if game.save
      redirect_to game, notice: 'Game invitation has been sent.'
      query_params = {}
      query_params.merge!(:login_token => opponent.login_token) if opponent.login_token
      Email.request_game(opponent.email, current_user.email, game_url(game, query_params)).deliver
    else
      render action: "new"
    end
  end

  def opponent_move
    board = params[:board]
    turn = params[:turn]
    @game = Game.find(params[:id])
    @game.board = board.join
    @game.turn = turn
    @game.save!
    render :json => true
  end

  def get_position
    @game = Game.find(params[:id])
    render :json => {
      :board => (@game.board || "---------").chars.to_a,
      :turn => @game.turn,
    }
  end

  # PUT /games/1
  # PUT /games/1.json
  def update
    @game = Game.find(params[:id])

    respond_to do |format|
      if @game.update_attributes(params[:game])
        format.html { redirect_to @game, notice: 'Game was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @game.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /games/1
  # DELETE /games/1.json
  def destroy
    @game = Game.find(params[:id])
    @game.destroy

    respond_to do |format|
      format.html { redirect_to games_url }
      format.json { head :no_content }
    end
  end
end
