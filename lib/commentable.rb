require 'comment'

module Commentable
  def self.included(base)
    base.attribute :comments
  end

  def initialize(*_, **a)
    super
    comment_tags = Array(a[:notes] || []).grep(Comment)
    comments = (a[:comments].presence || []).map { |s| Comment.new(s) }
    @comments = comments + comment_tags
  end

  def comment
    comments.join(', ')
  end
end
