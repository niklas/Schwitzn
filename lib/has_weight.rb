require 'weight'

module HasWeight
  def self.included(base)
    base.attribute :weight
  end

  def initialize(*_, **a)
    super
    @weight = Weight.wrap(a[:weight])
  end
end
