class Repetitions
  def self.wrap(first, second = nil)
    if second
      Times.new(first, second)
    else
      case first
      when Repetitions
        first
      when Array
        Sequence.new(first)
      when Hash
        Times.new(first[:sets], first[:reps])
      when Integer
        One.new(first)
      when /^\d+$/
        One.new(first)
      else
        raise ArgumentError.new("unsupported repetition: #{first}")
      end
    end
  end

  def to_i = total
  def ==(other)
    to_i == other.to_i
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
