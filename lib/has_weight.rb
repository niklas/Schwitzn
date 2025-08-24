require 'weight'

module HasWeight
  def self.included(base)
    base.attribute :weight
  end

  def initialize(*_, **a)
    super
    @weight = Weight.wrap(a[:weight] || 0.0)
  end

  def size_of_set(set)
    super(set) * @weight.total
  end
end
