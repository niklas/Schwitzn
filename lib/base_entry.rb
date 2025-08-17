class BaseEntry
  def self.attribute(name)
    attr_reader name
  end

  # Remove Object id
  def inspect
    super.sub(/^#([^:]+):0x[0-9a-f]+/i, "\\1")
  end
end
