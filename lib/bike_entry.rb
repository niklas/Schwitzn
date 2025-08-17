require 'entry'
require 'commentable'

class BikeEntry < Entry
  include Commentable
  attr_reader :reps
  attr_reader :duration

  def initialize(time, reps, duration, *a)
    super(time, 'Fahrrad', *a)
    @reps = reps
    @duration = duration
  end
end
