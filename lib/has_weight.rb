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

  def total_size
    super * @weight.total
  end

  def hover_text_of_set(_)
    "#{@weight.inspect} #{super}"
  end
end
