class BaseEntry
  class_attribute :attribute_names, default: []

  def self.attribute(name)
    attr_reader name
    self.attribute_names += [name]
  end

  # Remove Object id
  def inspect
    super.sub(/^#([^:]+):0x[0-9a-f]+/i, "\\1")
  end

  def ==(other)
    attribute_names.all? { |a| public_send(a) == other.public_send(a) }
  end
end
