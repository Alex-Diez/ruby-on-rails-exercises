class Game < ApplicationRecord
  validates :player, presence: true, length: { minimum: 5 }
  has_many :rolls

  NUMBER_OF_FRAMES = 10

  def roll(pin)
    save
    roll = rolls.create(pin: pin)
    roll.save
  end

  def score
    Enumerator
      .new { |indexes| generate_rolls_indexes(indexes) }
      .take(NUMBER_OF_FRAMES)
      .map { |index| compute_frame_points(index) }
      .reduce :+
  end

  private

  def generate_rolls_indexes(indexes)
    index = 0
    loop do
      indexes << index
      index += strike?(index) ? 1 : 2
    end
  end

  def compute_frame_points(index)
    if strike?(index)
      10 + strike_bonus(index)
    elsif spare?(index)
      10 + spare_bonus(index)
    else
      frame_points(index)
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
