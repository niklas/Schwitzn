module HasReps
  def self.included(base)
    base.attribute :reps
  end

  def initialize(*a, reps: reps)
    super(*a)
    @reps = reps && Integer(reps)
  end
end
