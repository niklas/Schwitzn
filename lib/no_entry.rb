class NoEntry < Entry
  include Commentable
  def initialize(time, **a)
    super(time, '---', **a)
  end
end
