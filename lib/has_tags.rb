require 'tag'

module HasTags
  def self.included(base)
    base.attribute :tags
  end

  def initialize(*_, **a)
    super
    tags_from_notes = Array(a[:notes] || []).grep(Tag)
    tags = (a[:tags].presence || []).map { |s| Tag.new(s) }
    @tags = tags_from_notes + tags
  end

  def has_tag?(needle)
    @tags.include?(needle)
  end

  def annotations
    "#{@tags.map(&:icon).join()} #{super}"
  end

  def hover_text_of_set(_)
    "#{super} #{hash_tags.join(' ')}"
  end

  def hash_tags
    @tags.map { |t| "##{t}" }
  end
end
