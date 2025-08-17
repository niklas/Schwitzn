class Measurement
  attr_reader :count
  attr_reader :unit
  def initialize(count, unit = self.class.default_unit)
    @count = Integer(count)
    @unit = unit
  end

  def ==(o)
    count == o.count && unit == o.unit
  end

  def inspect
    %Q(#{count}#{unit})
  end

  def self.default_unit = 'units'
end
