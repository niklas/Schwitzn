module HasName
  UNKNOWN = "[[unknown]]"
  def self.included(base)
    base.attribute :name
  end

  def initialize(*_, **a)
    super
    @name = (a[:name] || UNKNOWN).to_s
  end
end
