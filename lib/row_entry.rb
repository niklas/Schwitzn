require 'entry'
require 'distance'

class RowEntry < Entry
  attr_reader :reps
  attr_reader :duration
  attr_reader :level
  attr_reader :distance
  attr_reader :comments

  def initialize(time, reps, duration, level, tags = [], distance = nil, comments = nil)
    distances, tags = (tags || []).partition { |t| t.is_a?(Distance) }
    comment_tags, tags = (tags || []).partition { |t| t.is_a?(Comment) }
    super(time, "Rowing", tags)
    @reps = reps
    @duration = duration
    @level = level
    @distance = distance || distances.first
    @comments = comments || comment_tags
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
