class BikeEntry < Entry
  include Commentable
  include HasDistance
  attribute :reps
  attribute :duration

  def initialize(time, reps, duration, *a)
    super(time, 'Fahrrad', *a)
    @reps = reps
    @duration = duration
  end
end
