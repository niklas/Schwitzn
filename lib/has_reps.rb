module HasReps
  def self.included(base)
    base.attribute :reps
    delegate :reps_in_set, to: :reps
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
            else
              Repetitions.none
            end
  end

  def size_of_set(set)
    reps_in_set(set) * super
  end

  def hover_text_of_set(set)
    "#{reps_in_set(set)}x #{super}"
  end
end
