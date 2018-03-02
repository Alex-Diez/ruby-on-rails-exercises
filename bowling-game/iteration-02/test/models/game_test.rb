require 'test_helper'

class GameTest < ActiveSupport::TestCase
  context 'player name' do
    setup do
      @game = Game.new({ player: nil, rolls: [] })
    end

    should 'be presented' do
      assert_equal false, @game.valid?
    end

    should 'be longer than 4 characters' do
      assert_equal false, @game.valid?
    end
  end

  def roll_many(count, pin)
    count.times { @game.roll pin }
  end

  def roll_spare
    @game.roll 4
    @game.roll 6
  end

  context 'game' do
    setup do
      @game = Game.new({ player: 'player1', rolls: [] })
    end

    should 'compute gutter result' do
      roll_many 20, 0

      assert_equal 0, @game.score
    end

    should 'compute all ones result' do
      roll_many 20, 1

      assert_equal 20, @game.score
    end

    should 'compute one spare' do
      roll_spare
      @game.roll 3
      roll_many 17, 0

      assert_equal 16, @game.score
    end

    should 'compute one strike' do
      @game.roll 10
      @game.roll 4
      @game.roll 3
      roll_many 16, 0

      assert_equal 24, @game.score
    end
  end
end
