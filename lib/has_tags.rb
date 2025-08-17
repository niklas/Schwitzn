require 'tag'

module HasTags
  def self.included(base)
    base.attribute :tags
  end

  def initialize(*_, **a)
    super
    tags_from_notes, _ = (a[:notes] || []).partition { |n| n.is_a?(Tag) }
    tags = (a[:tags].presence || []).map { |s| Tag.new(s) }
    @tags = tags_from_notes + tags
  end
end
