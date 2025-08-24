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

  delegate :reps_in_set, to: :reps

  def initialize(**a)
    super(**a)

    @details = comments.grep(/band/)
    @pullup_reps = a[:pullup_reps]

    parse_details
  end

  def reps
    @reps ||= Repetitions.wrap(@pullup_reps)
  end

  def band_support?
    @band_support
  end

  def color_in_set(set, total)
    @color ||= case band_color
               when 'green'
                 Color.green
               when 'blue'
                 Color.blue
               when 'black'
                 Color.black
               when nil # no band
                 Color.skin
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
