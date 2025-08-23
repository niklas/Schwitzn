require 'detailed_workout'
class DetailedWorkout < Entry
  # Workouts with a list of exercises
  NAMES = %w(
    HB1
  ).freeze

  attribute :exercises

  def initialize(**a)
    super
    @exercises = Array(a[:exercises])
    @exercises.each do |exercise|
      exercise.belongs_to(self)
    end
  end
end
