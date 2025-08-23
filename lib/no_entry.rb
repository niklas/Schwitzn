require 'entry'
class NoEntry < Entry
  include Commentable
  def initialize(**a)
    super(name: '---', **a)
  end
end
