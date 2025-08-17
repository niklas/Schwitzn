require 'duration'

module HasDuration
  def self.included(base)
    base.attribute :duration
  end

  def initialize(*_, **a)
    super
    durations = (a[:notes] || []).grep(Duration)
    duration = a[:duration]
    @duration = durations.first || (duration && Duration.new(duration))
  end
end
