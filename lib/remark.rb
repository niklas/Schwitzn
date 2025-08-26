require 'entry'
class Remark < Entry
  include Commentable
  def initialize(**a)
    super(name: '_Remark', **a)
  end
end
