require 'duration'

module HasDuration
  def self.included(base)
    base.attribute :duration
  end

  def initialize(*_, **a)
    super
    durations = Array(a[:notes] || []).grep(Duration)
    @duration = durations.first || Duration.wrap(a[:duration] || 0)
  end

  def size_of_set(set)
    super(set) * @duration.total
  end

  def total_size
    super * @weight.total
  end

  def hover_text_of_set(_)
    "#{@duration.inspect} #{super}"
  end
end
