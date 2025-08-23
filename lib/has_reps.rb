module HasReps
  def self.included(base)
    base.attribute :reps
  end

  def initialize(*_, **a)
    super
    reps = a[:reps]
    @reps = case reps
            when {reps: reps, sets: sets}
              self.sets = sets
              reps
            when Integer
              reps
            when /^\d+$/
              parse(reps)
            when Array
              reps.map(&method(:parse))
            else
              1
            end
  end

  def parse(num)
    Integer(num)
  end
end
