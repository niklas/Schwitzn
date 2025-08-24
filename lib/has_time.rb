module HasTime
  def self.included(base)
    base.attribute :time
  end

  def initialize(*_, **a)
    super
    @time = a[:time]
    unless @time == :parent
      @time = Time.parse(@time) || raise("could not parse time: #{@time}")
    end
  end

  def formatted_time
    HasTime.format(@time)
  end

  def self.format(time)
    time.strftime('%F %T')
  end
end
