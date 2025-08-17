require 'distance'

module HasDistance
  def self.included(base)
    base.attribute :distance
  end

  def initialize(*_, **a)
    super
    distances = (a[:notes] || []).grep(Distance)
    distance = a[:distance]
    @distance = distances.first || (distance && Distance.new(distance))
  end
end
