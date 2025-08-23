class FerengiEntry < Entry
  include HasReps
  include Commentable

  def initialize(**opts)
    super(name: 'Ferengi', **opts)
  end
end
