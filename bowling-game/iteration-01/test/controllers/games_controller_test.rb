require 'test_helper'
require 'shoulda/context'

class GamesControllerTest < ActionDispatch::IntegrationTest
  included ActionController::TemplateAssertions

  context 'get requests to /games' do
    setup do
      get '/games'
    end

    should 'respond with success' do
      assert_response :success
    end

    should 'have list of games on /games' do
      assert_equal Game.all, assigns(:games)
    end
  end

  context 'post request to /games' do
    should 'create new game' do
      post '/games', params: { game: { player: 'Player', rolls: [] } }

      assert_redirected_to game_path(Game.last)
    end

    should 'render new view when player name is not valid' do
      post '/games', params: { game: { player: 'pla', rolls: [] } }

      assert_equal Game.all, assigns(:games)
      assert_template :index
    end
  end

  context 'get request to /games/:id' do
    setup do
      get '/games/' + Game.last.id.to_s
    end

    should 'respond with success' do
      assert_response :success
    end

    should 'show game content' do
      assert_equal Game.last, assigns(:game)
    end
  end

  context 'put request to /games/:id' do
    setup do
      put '/games/' + Game.last.id.to_s, params: { game: { pin: 2 } }
    end

    should 'update game score' do
      assert_equal 2, Game.last.score
    end

    should 'render show view' do
      assert_template :show
    end
  end
end
