require 'entry'
require 'commentable'

# Full Body Strength Circwhatevs
class FBSCEntry < Entry
  NAMES = %w(
    FBSC1
  ).freeze
  include Commentable
  include HasTags
  include HasPause
  attribute :details
  attribute :band_color
  attribute :pullup_reps

  def initialize(**a)
    super(**a)

    @details = comments.grep(/band/)
    @pullup_reps = a[:pullup_reps]

    parse_details
  end

  def band_support?
    @band_support
  end

  def reps_in_set(num)
    @pullup_reps[num-1] || 0
  end

  def color_in_set(set, total)
    @color ||= case band_color
               when 'green'
                 'rgba(10,200,10,1)'
               when 'blue'
                 'rgba(10,10,200,1)'
               when 'black'
                 'rgba(10,10,10,1)'
               when nil # no band
                 'rgba(186,165,121, 0.3)' # skin color
               else
                 raise "cannot find color_in_set for #{band_color}\n#{inspect}"
               end
  end

  def parse_details
    @details.each do |detail|
      case detail
      when /^(black|blue|green|red) band$/
        @band_color = $1
      end
    end
    @band_support = has_tag?('support')
  end
end
