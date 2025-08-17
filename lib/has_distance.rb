require 'distance'

module HasDistance
  def self.included(base)
    base.attribute :distance
  end

  def initialize(*_, **a)
    super
    distances, _ = (a[:notes] || []).partition { |t| t.is_a?(Distance) }
    distance = a[:distance]
    @distance = distances.first || (distance && Distance.new(distance))
  end
end
