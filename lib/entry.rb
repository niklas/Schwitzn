require 'time'
require 'base_entry'
require 'has_name'
require 'has_time'

class Entry < BaseEntry
  include HasTime
  include HasName

  def exercises = [self]

  def color_in_set(_set, _total)
    'rgba(42,42,42,1)'
  end
end
