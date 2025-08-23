class Repetitions
  def self.wrap(first, second = nil)
    if second
      Times.new(first, second)
    else
      if first.is_a?(Enumerable)
        Sequence.new(first)
      else
        One.new(first)
      end
    end
  end

  class Times
    def initialize(factor, n)
      @factor = Integer(factor)
      @n = Integer(n)
    end

    def total = @factor * @n
    def inspect = "#{@factor}x#{@n}"
  end

  class One
    def initialize(n)
      @n = Integer(n)
    end

    def total = @n
    def inspect = @n.to_s
  end

  class Sequence
    def initialize(seq)
      @seq = seq.map { |e| Integer(e) }
    end

    def total = @seq.sum
    def inspect = @seq.join('-')
  end

end
