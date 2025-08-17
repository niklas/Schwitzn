module HasTags
  def self.included(base)
    base.attribute :tags
  end

  def initialize(*_, **a)
    super
    tags_from_notes, _ = (a[:notes] || []).partition { |n| n.is_a?(String) }
    @tags = tags_from_notes + (a[:tags] || [])
  end
end
