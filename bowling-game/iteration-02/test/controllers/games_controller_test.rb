require 'test_helper'

class GamesControllerTest < ActionDispatch::IntegrationTest
  context 'get /games' do
    setup do
      get '/games'
    end

    should 'get /games respond with success' do
      assert_response :success
    end

    should 'show list of all games' do
      assert_equal Game.all, assigns(:games)
    end
  end

  context 'successful post /games' do
    setup do
      post '/games', params: { game: { player: 'Player1', rolls: [] } }
    end

    should 'respond with success' do
      assert_response :redirect
    end

    should 'show newly created game' do
      assert_redirected_to game_path(Game.last)
    end
  end

  context 'unsuccessful post /games' do
    should 'render list of games' do
      too_short_player_name = 's'
      post '/games', params: { game: { player: too_short_player_name, rolls: [] } }

      assert_equal Game.all, assigns(:games)
      assert_template :index
    end
  end

  context 'get /games/:id' do
    setup do
      @game = Game.last
      get "/games/#{@game.id}"
    end

    should 'respond with success' do
      assert_response :success
    end

    should 'show content of the game' do
      assert @game, assigns(:game)
    end
  end

  context 'put /games/:id' do
    setup do
      put "/games/#{Game.last.id}", params: { game: { pin: 2 } }
    end

    should 'respond with success' do
      assert_response :success
    end

    should 'update game score' do
      assert_equal 2, Game.last.score
    end
  end
end
