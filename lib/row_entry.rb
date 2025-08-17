require 'entry'

class RowEntry < Entry
  attr_reader :reps
  attr_reader :duration
  attr_reader :level

  def initialize(time, reps, duration, level, tags = [])
    super(time, "Rowing", tags)
    @reps = reps
    @duration = duration
    @level = level
  end

  def ==(other)
    super(other) &&
      reps == other.reps &&
      duration == other.duration &&
      level == other.level
  end
end
