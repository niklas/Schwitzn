require 'time'
require 'base_entry'
require 'has_name'
require 'has_time'

class Entry < BaseEntry
  include HasTime
  include HasName

  def exercises = [self]
end
