require 'time'

class Entry
  attr_reader :time
  def initialize(time)
    @time = Time.parse(time) || raise("could not parse time: #{time}")
  end

  def formatted_time
    @time.strftime('%F %T')
  end
end
