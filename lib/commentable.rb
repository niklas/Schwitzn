require 'comment'

module Commentable
  def self.included(base)
    base.attribute :comments
  end

  def initialize(*a, notes: (notes || []))
    super(*a)
    comment_tags, _ = (notes || []).partition { |t| t.is_a?(Comment) }
    @comments = comments || comment_tags
  end
end
