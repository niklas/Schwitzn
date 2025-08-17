class RowEntry < Entry
  include Commentable
  include HasDistance
  include HasTags
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
