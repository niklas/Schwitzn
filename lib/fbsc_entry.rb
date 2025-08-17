require 'entry'
require 'commentable'

# Full Body Strength Circwhatevs
class FBSCEntry < Entry
  include Commentable
  attr_reader :details
  attr_reader :band_color
  attr_reader :pullup_reps

  def initialize(time, workout_name, details, pullup_reps, *a)
    super(time, workout_name, *a)

    @details = details
    @pullup_reps = pullup_reps

    parse_details
  end

  def band_support?
    @band_support
  end

  def reps_in_set(num)
    @pullup_reps[num-1] || 0
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
