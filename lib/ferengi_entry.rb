class FerengiEntry < Entry
  include HasReps
  include Commentable

  def initialize(time, **opts)
    super(time, 'Ferengi', **opts)
  end
end
