module HasReps
  def self.included(base)
    base.attribute :reps
  end

  def initialize(*_, **a)
    super
    reps = a[:reps]
    sets = a[:sets]
    @reps = if reps
              if sets
                Repetitions.wrap(sets, reps)
              else
                Repetitions.wrap(reps)
              end
            end
  end
end
