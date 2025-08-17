class RowEntry < Entry
  include Commentable
  include HasDistance
  include HasTags
  include HasReps
  attribute :duration
  attribute :level

  def initialize(time, duration, level, *a)
    super(time, "Rowing", *a)
    @duration = duration
    @level = level
  end
end
