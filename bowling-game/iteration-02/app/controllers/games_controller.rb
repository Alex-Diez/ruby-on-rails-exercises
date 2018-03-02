class GamesController < ApplicationController
  def index
    @games = Game.all
  end

  def show
    @game = Game.find(params[:id])
  end

  def create
    @game = Game.new(new_game_params)

    if @game.save
      redirect_to @game
    else
      @games ||= Game.all
      render 'index'
    end
  end

  def update
    @game = Game.find(params[:id])
    @game.roll roll_ball_params

    render 'show'
  end

  private

  def new_game_params
    params.require(:game).permit(:player, :rolls)
  end

  def roll_ball_params
    params.require(:game).permit(:pin, :int)[:pin].to_i
  end
end
