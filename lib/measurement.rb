require 'value_wrapper'

class Measurement < ValueWrapper
  attr_reader :count
  attr_reader :unit
  def initialize(count, unit = self.class.default_unit)
    @count = Integer(count)
    @unit = unit
  end

  def ==(o)
    normalized == o.normalized
  end

  def inspect
    %Q(#{count}#{unit})
  end

  def normalized
    case unit
    when 'km' then count * 1000
    else count
    end
  end

  def self.default_unit = 'units'
end
