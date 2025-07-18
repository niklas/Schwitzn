require 'entry'

class FSBCEntry < Entry
  attr_reader :comment
  attr_reader :details
  attr_reader :band_color

  def initialize(time, workout_name, details, num_sets, comment)
    super(time, workout_name)

    @details = details
    @num_sets = num_sets.split('-').map(&:to_i)
    @comment = comment

    parse_details
  end

  def band_support?
    @band_support
  end

  def reps_in_set(num)
    @num_sets[num-1] || 0
  end

  def color_in_set(set, total)
    @color ||= case @details
               when /green band.*support/
                 'rgba(10,200,10,1)'
               when /blue band.*support/
                 'rgba(10,10,200,1)'
               when /black band.*support/
                 'rgba(10,10,10,1)'
               else
                 raise "cannot find color in #{@details}"
               end
  end

  def parse_details
    case @details
    when /^(black|blue|green|red) band$/
      @band_color = $1
    when /^(black|blue|green|red) band, support$/
      @band_color = $1
      @band_support = true
    end
  end
end
