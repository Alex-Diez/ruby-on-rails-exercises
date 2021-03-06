require 'test_helper'

class GamesControllerTest < ActionDispatch::IntegrationTest
  context 'GET /games' do
    setup do
      get '/games'
    end

    should 'respond with success' do
      assert_response :success
    end

    should 'return list of all games' do
      assert_equal Game.all, assigns(:games)
    end
  end

  context 'successful POST /games' do
    setup do
      post '/games', params: { game: { player: 'player1' } }
    end

    should 'respond with redirect' do
      assert_response :redirect
    end

    should 'create game' do
      assert_redirected_to game_path(Game.last)
    end
  end

  context 'unsuccessful POST /games' do
    should 'show index page when model is invalid' do
      too_short_player_name = 's'
      post '/games', params: { game: { player: too_short_player_name } }

      assert_equal Game.all, assigns(:games)
      assert_template :index
    end
  end

  context 'GET /games/:id' do
    setup do
      @game = Game.last
      get "/games/#{@game.id}"
    end

    should 'respond with success' do
      assert_response :success
    end

    should 'show the game' do
      assert @game, assigns(:game)
    end

    should 'render show view' do
      assert_template :show
    end
  end

  context 'PUT /games/:id' do
    setup do
      @game = Game.last
      put "/games/#{@game.id}", params: { game: { pin: 1 } }
    end

    should 'respond with success' do
      assert_response :success
    end

    should 'render show view' do
      assert_template :show
    end

    should 'show game' do
      assert @game, assigns(:game)
    end
  end
end
