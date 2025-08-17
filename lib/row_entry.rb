require 'entry'
require 'distance'

class RowEntry < Entry
  attr_reader :reps
  attr_reader :duration
  attr_reader :level
  attr_reader :distance

  def initialize(time, reps, duration, level, tags = [], distance = nil)
    distances, tags = (tags || []).partition { |t| t.is_a?(Distance) }
    super(time, "Rowing", tags)
    @reps = reps
    @duration = duration
    @level = level
    @distance = distance || distances.first
  end

  def ==(other)
    super(other) &&
      reps == other.reps &&
      duration == other.duration &&
      distance == other.distance &&
      level == other.level
  end
end
