class Distance
  attr_reader :count
  attr_reader :unit
  def initialize(count, unit = 'm')
    @count = Integer(count)
    @unit = unit
  end

  def ==(o)
    count == o.count && unit == o.unit
  end
end
