require 'distance'

module HasDistance
  def self.included(base)
    base.attribute :distance
  end

  def initialize(*_, **a)
    super
    distances = (a[:notes] || []).grep(Distance)
    @distance = distances.first || Distance.wrap(a[:distance])
  end
end
