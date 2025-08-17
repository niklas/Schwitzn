require 'entry'
require 'commentable'

class RowEntry < Entry
  include Commentable
  attr_reader :reps
  attr_reader :duration
  attr_reader :level

  def initialize(time, reps, duration, level, *a)
    super(time, "Rowing", *a)
    @reps = reps
    @duration = duration
    @level = level
  end

  def ==(other)
    super(other) &&
      reps == other.reps &&
      duration == other.duration &&
      distance == other.distance &&
      comments.map(&:to_s) == other.comments.map(&:to_s) &&
      level == other.level
  end
end
