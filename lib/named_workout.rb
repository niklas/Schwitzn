require 'entry'
require 'has_duration'
class NamedWorkout < Entry
  # Workouts only mentioned by name
  NAMES = %w(
    BACK1
    FRS1
    MAB
  ).freeze

  include HasDuration
end
