class Game < ApplicationRecord
  validates :player, presence: true, length: { minimum: 5 }
  has_many :rolls

  def roll(pin)
    save
    roll = rolls.create(pin: pin)
    roll.save
  end

  def score
    Enumerator
      .new { |indexes| generate_rolls_indexes(indexes) }
      .take(10)
      .map { |roll| compute_frame_points(roll) }
      .reduce(:+)
  end

  private

  def compute_frame_points(roll)
    if strike?(roll)
      10 + strike_bonus(roll)
    elsif spare?(roll)
      10 + spare_bonus(roll)
    else
      frame_points(roll)
    end
  end

  def generate_rolls_indexes(indexes)
    index = 0
    loop do
      indexes << index
      index += strike?(index) ? 1 : 2
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
    rolls[roll] ? rolls[roll].pin : 0
  end
end
