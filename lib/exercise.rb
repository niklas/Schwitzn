require 'entry'
class Exercise < Entry
  include Commentable
  include HasWeight
  include HasReps
  include HasTags
  include HasTime

  def belongs_to(parent)
    @time = parent.time if time == :parent
  end
end
