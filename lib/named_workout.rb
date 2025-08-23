require 'entry'
class NamedWorkout < Entry
  # Workouts only mentioned by name
  NAMES = %w(
    BACK1
    FRS1
  ).freeze
end
