require 'comment'
require 'distance'
module Commentable
  def self.included(base)
    base.attribute :comments
    base.attribute :distance
    base.attribute :tags
  end

  def initialize(*a, notes: (notes || []))
    super(*a)
    distances, notes = (notes || []).partition { |t| t.is_a?(Distance) }
    comment_tags, notes = (notes || []).partition { |t| t.is_a?(Comment) }
    @distance = distance || distances.first
    @comments = comments || comment_tags
    @tags = notes
  end
end
