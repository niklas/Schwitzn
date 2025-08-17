require 'pause'

module HasPause
  def self.included(base)
    base.attribute :pause
  end

  def initialize(*_, **a)
    super
    pauses_from_notes = (a[:notes] || []).grep(Pause)
    @pause = pauses_from_notes.first || a[:pause]
  end
end
