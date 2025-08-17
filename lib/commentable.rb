require 'comment'

module Commentable
  def self.included(base)
    base.attribute :comments
    base.attribute :tags
  end

  def initialize(*a, notes: (notes || []))
    super(*a)
    comment_tags, notes = (notes || []).partition { |t| t.is_a?(Comment) }
    @comments = comments || comment_tags
    @tags = notes
  end
end
