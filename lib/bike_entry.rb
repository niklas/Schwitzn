require 'entry'

class BikeEntry < Entry
  attr_reader :reps
  attr_reader :duration
  attr_reader :comments

  def initialize(time, reps, duration, comments = nil)
    super(time, 'Fahrrad')
    @reps = reps
    @duration = duration
    @comments = comments
  end
end
