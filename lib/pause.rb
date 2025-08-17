require 'duration'
class Pause < Duration
  def initialize(min:, sec:)
    super(
      Integer(min) * 60 + Integer(sec),
      's'
    )
  end
end
