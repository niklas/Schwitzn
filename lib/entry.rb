require 'time'

class Entry
  attr_reader :time
  attr_reader :workout_name

  def initialize(time, workout_name = 'Workout', *rest)
    @time = Time.parse(time) || raise("could not parse time: #{time}")
    @workout_name = workout_name
  end

  def formatted_time
    @time.strftime('%F %T')
  end

  def ==(other)
    time == other.time &&
      tags == other.tags &&
      workout_name == other.workout_name
  end

  # Remove Object id
  def inspect
    super.sub(/^#([^:]+):0x[0-9a-f]+/i, "\\1")
  end
end
