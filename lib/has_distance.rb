require 'distance'

module HasDistance
  def self.included(base)
    base.attribute :distance
  end

  def initialize(*_, **a)
    super
    distances = (a[:notes] || []).grep(Distance)
    @distance = distances.first || Distance.wrap(a[:distance] || 0)
  end

  def size_of_set(set)
    super(set) * @distance.total_factor
  end

  def total_size
    super * @distance.total_factor
  end

  def hover_text_of_set(_)
    "#{@distance.inspect} #{super}"
  end
end
