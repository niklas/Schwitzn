require 'time'
require 'base_entry'

class Entry < BaseEntry
  attribute :time
  attribute :workout_name

  def initialize(time, workout_name = 'Workout', *rest)
    super()
    @time = Time.parse(time) || raise("could not parse time: #{time}")
    @workout_name = workout_name
  end

  def formatted_time
    @time.strftime('%F %T')
  end
end
