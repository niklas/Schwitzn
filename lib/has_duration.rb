require 'duration'

module HasDuration
  def self.included(base)
    base.attribute :duration
  end

  def initialize(*_, **a)
    super
    durations = Array(a[:notes] || []).grep(Duration)
    @duration = durations.first || Duration.wrap(a[:duration])
  end
end
