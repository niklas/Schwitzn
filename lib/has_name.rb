module HasName
  def self.included(base)
    base.attribute :name
  end

  def initialize(*_, **a)
    super
    @name = a[:name]
  end
end
