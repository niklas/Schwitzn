module HasTags
  def self.included(base)
    base.attribute :tags
  end

  def initialize(*a, notes: (notes || []), tags: (tags || []))
    super(*a)
    tags_from_notes, _ = (notes || []).partition { |n| n.is_a?(String) }
    @tags = tags_from_notes + tags
  end
end
