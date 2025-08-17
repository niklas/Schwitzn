module HasReps
  def self.included(base)
    base.attribute :reps
  end

  def initialize(*_, **a)
    super
    reps = a[:reps]
    @reps = reps && Integer(reps)
  end
end
