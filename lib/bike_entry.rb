class BikeEntry < Entry
  include Commentable
  include HasDistance
  include HasDuration
  include HasTags
  include HasReps

  def initialize(time, **a)
    super(time, 'Fahrrad', **a)
  end
end
