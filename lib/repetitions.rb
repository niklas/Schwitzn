class Repetitions
  def self.wrap(first, second = nil)
    if second
      Times.new(first, second)
    else
      if first.is_a?(Repetitions)
        first
      elsif first.is_a?(Enumerable)
        Sequence.new(first)
      else
        One.new(first)
      end
    end
  end

  class Times < Repetitions
    def initialize(sets, n)
      @sets = Repetitions.parse_num(sets)
      @n = Repetitions.parse_num(n)
    end

    def total = @sets * @n
    def inspect = "#{@sets}x#{@n}"
  end

  class One < Repetitions
    def initialize(n)
      @n = Repetitions.parse_num(n)
    end

    def total = @n
    def inspect = @n.to_s
  end

  class Sequence < Repetitions
    def initialize(seq)
      @seq = seq.map { |e| Repetitions.parse_num(e) }
    end

    def total = @seq.sum
    def inspect = @seq.join('-')
  end


  def self.parse_num(num)
    Integer(num)
  end
end
