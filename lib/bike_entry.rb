class BikeEntry < Entry
  include Commentable
  include HasDistance
  include HasTags
  include HasReps
  attribute :duration

  def initialize(time, duration, *a)
    super(time, 'Fahrrad', *a)
    @duration = duration
  end
end
