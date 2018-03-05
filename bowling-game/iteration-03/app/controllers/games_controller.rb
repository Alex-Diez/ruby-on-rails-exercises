class GamesController < ApplicationController
  def index
    @games = Game.all
  end

  def show
    @game = Game.find(params[:id])
  end

  def create
    @game = Game.new(params.require(:game).permit(:player))

    if @game.save
      redirect_to @game
    else
      @games = Game.all
      render 'index'
    end
  end

  def update
    @game = Game.find(params[:id])

    @game.roll(params.require(:game).permit(:pin)[:pin].to_i)

    render 'show'
  end
end
