require 'test_helper'

class GameTest < ActiveSupport::TestCase
  context 'model validation' do
    should 'game should have player name' do
      game = Game.new(player: nil)

      assert(!game.valid?)
    end

    should 'game player should have at least 5 chars in name' do
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
      @game = Game.new(player: 'player')
    end

    should 'compute gutter game' do
      roll_many 20, 0

      assert_equal 0, @game.score
    end

    should 'compute all ones' do
      roll_many 20, 1

      assert_equal 20, @game.score
    end

    should 'compute game with one spare' do
      roll_spare
      @game.roll 3
      roll_many 17, 0

      assert_equal 16, @game.score
    end

    should 'compute game with one strike' do
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
