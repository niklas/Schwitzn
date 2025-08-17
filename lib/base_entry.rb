class BaseEntry
  def self.attribute(name)
    attr_reader name
  end
end
