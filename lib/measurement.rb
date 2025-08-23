require 'value_wrapper'

class Measurement < ValueWrapper
  attr_reader :count
  attr_reader :unit
  attr_reader :mult
  def initialize(count, unit = self.class.default_unit, mult = 1)
    @count = case count
             when Numeric
               count
             when /^\d+\.\d+$/
               Float(count)
             when /^\d+$/
               Integer(count)
             end
    @unit = unit
    @mult = Integer(mult)
  end

  def ==(o)
    normalized == o.normalized
  end

  def inspect
    if mult == 1
      %Q(#{count}#{unit})
    else
      %Q(#{mult}x#{count}#{unit})
    end
  end

  def normalized
    case unit
    when 'km' then total * 1000
    when 'h' then total * 60 * 60
    when 'min' then total * 60
    else total
    end
  end

  def total
    count * mult
  end

  def self.default_unit = 'units'
end
