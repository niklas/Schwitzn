require 'measurement'
class Weight < Measurement
  def self.default_unit = 'kg'

  def inspect = "@#{super}"
end
