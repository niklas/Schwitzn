require 'entry'
class Exercise < Entry
  include Commentable
  include HasWeight
  include HasReps
  include HasTags
  include HasSets

  def belongs_to(parent)
    @time = parent.time if time == :parent
  end
end
