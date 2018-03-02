class Game < ApplicationRecord
  NUMBER_OF_FRAMES = 10

  validates :player, presence: true, length: { minimum: 5 }

  serialize :rolls, Array

  def roll(pin)
    rolls << pin
    save
  end

  def score
    Enumerator
      .new { |rolls| generate_rolls_indexes(rolls) }
      .take(NUMBER_OF_FRAMES)
      .map { |roll| compute_frames_points(roll) }
      .reduce(:+)
  end

  private

  def generate_rolls_indexes(rolls)
    index = 0
    loop do
      rolls << index
      index += strike?(index) ? 1 : 2
    end
  end

  def compute_frames_points(roll)
    if strike?(roll)
      10 + strike_bonus(roll)
    elsif spare?(roll)
      10 + spare_bonus(roll)
    else
      frame_points(roll)
    end
  end

  def strike?(roll)
    roll_at(roll) == 10
  end

  def strike_bonus(roll)
    roll_at(roll + 1) + roll_at(roll + 2)
  end

  def spare?(roll)
    frame_points(roll) == 10
  end

  def spare_bonus(roll)
    roll_at(roll + 2)
  end

  def frame_points(roll)
    roll_at(roll) + roll_at(roll + 1)
  end

  def roll_at(roll)
    rolls[roll] || 0
  end
end
