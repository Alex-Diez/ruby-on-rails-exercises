require 'test_helper'

class GameTest < ActiveSupport::TestCase

  setup do
    @game = games(:one)
  end

  private

  def roll_many(count, pin)
    count.times { @game.roll pin }
  end

  def roll_spare
    @game.roll 4
    @game.roll 6
  end

  def roll_strike
    @game.roll 10
  end

  test 'game must have player name' do
    @game.player = nil

    assert_equal false, @game.valid?
  end

  test 'player name should have at least 5 chars length' do
    @game.player = 'olo'

    assert_equal false, @game.valid?
  end

  test 'compute score for gutter game' do
    roll_many 20, 0

    assert_equal 0, @game.score
  end


  test 'compute score for all ones game' do
    roll_many 20, 1

    assert_equal 20, @game.score
  end

  test 'compute score for game with one spare' do
    roll_spare
    @game.roll 3
    roll_many 17, 0

    assert_equal 16, @game.score
  end

  test 'compute score for game with one strike' do
    roll_strike
    @game.roll 4
    @game.roll 3
    roll_many 16, 0

    assert_equal 24, @game.score
  end

  test 'compute score for perfect game' do
    roll_many 12, 10

    assert_equal 300, @game.score
  end
end
