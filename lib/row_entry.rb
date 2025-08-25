class RowEntry < Entry
  include Commentable
  include HasDistance
  include HasTags
  include HasReps
  attribute :duration
  attribute :level

  def initialize(duration, level, **a)
    super(**a)
    @duration = duration
    @level = level
  end

  def name
    'Rowing machine'
  end
end
