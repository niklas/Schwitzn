module HasSets
  def self.included(base)
    base.attribute :sets
  end

  def initialize(*_, **a)
    super
    sets = a[:sets]
    @sets = sets && Integer(sets) || 1
  end
end
