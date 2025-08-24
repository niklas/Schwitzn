require 'entry'
class Exercise < Entry
  include Commentable
  include HasReps
  include HasWeight
  include HasTags

  def belongs_to(parent)
    @time = parent.time if time == :parent
  end
end
