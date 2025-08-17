class ValueWrapper
  def self.wrap(obj)
    return if obj.nil?
    return obj if obj.is_a?(self)
    new(obj)
  end
end
