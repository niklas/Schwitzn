class BikeEntry < Entry
  include Commentable
  include HasDistance
  include HasDuration
  include HasTags
  include HasReps

  def initialize(**a)
    super(name: 'Fahrrad', **a)
  end
end
