require 'comment'
require 'distance'
module Commentable
  def self.included(base)
    base.attr_reader :comments
    base.attr_reader :distance
    base.attr_reader :tags
  end

  def initialize(*a, notes: (notes || []))
    distances, notes = (notes || []).partition { |t| t.is_a?(Distance) }
    comment_tags, notes = (notes || []).partition { |t| t.is_a?(Comment) }
    @distance = distance || distances.first
    @comments = comments || comment_tags
    @tags = notes
  end
end
