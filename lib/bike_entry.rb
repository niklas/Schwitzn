require 'entry'
require 'commentable'

class BikeEntry < Entry
  include Commentable
  attribute :reps
  attribute :duration

  def initialize(time, reps, duration, *a)
    super(time, 'Fahrrad', *a)
    @reps = reps
    @duration = duration
  end
end
