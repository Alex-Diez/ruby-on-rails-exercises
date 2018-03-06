require 'test_helper'

class GameTest < ActiveSupport::TestCase
  context 'player name' do
    should 'not be nil' do
      game = Game.new(player: nil)

      assert(!game.valid?)
    end

    should 'be at least 5 chars long' do
      game = Game.new(player: 'four')

      assert(!game.valid?)
    end
  end

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

  context 'bowling game' do
    setup do
      @game = Game.new(player: 'Player-1')
    end

    should 'compute gutter game' do
      roll_many 20, 0

      assert_equal 0, @game.score
    end

    should 'compute all ones game' do
      roll_many 20, 1

      assert_equal 20, @game.score
    end

    should 'compute one spare game' do
      roll_spare
      @game.roll 3
      roll_many 17, 0

      assert_equal 16, @game.score
    end

    should 'compute one strike game' do
      roll_strike
      @game.roll 4
      @game.roll 3
      roll_many 16, 0

      assert_equal 24, @game.score
    end

    should 'compute perfect game' do
      roll_many 12, 10

      assert_equal 300, @game.score
    end
  end
end
