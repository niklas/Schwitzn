require 'distance'

module HasDistance
  def self.included(base)
    base.attribute :distance
  end

  def initialize(*a, notes: (notes || []), distance: distance)
    super(*a)
    distances, _ = (notes || []).partition { |t| t.is_a?(Distance) }
    @distance = distances.first || (distance && Distance.new(distance))
  end
end
