require 'comment'

module Commentable
  def self.included(base)
    base.attribute :comments
  end

  def initialize(*_, **a)
    super
    comment_tags, _ = (a[:notes] || []).partition { |t| t.is_a?(Comment) }
    comments = (a[:comments].presence || []).map { |s| Comment.new(s) }
    @comments = comments + comment_tags
  end
end
