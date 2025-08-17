require 'entry'
require 'commentable'

class RowEntry < Entry
  include Commentable
  attribute :reps
  attribute :duration
  attribute :level

  def initialize(time, reps, duration, level, *a)
    super(time, "Rowing", *a)
    @reps = reps
    @duration = duration
    @level = level
  end
end
