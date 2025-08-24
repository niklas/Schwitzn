require 'entry'
require 'commentable'

# Full Body Strength Circwhatevs
class FBSCEntry < Entry
  NAMES = %w(
    FBSC1
  ).freeze
  BAND_FACTOR = {
    'red'   => 0.95,
    'black' => 0.9,
    'blue'  => 0.8,
    'green' => 0.7,
  }.freeze

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

  def size_of_set(set)
    reps_in_set(set) * band_factor
  end

  def total_size
    super * reps.total * band_factor
  end

  def reps
    @reps ||= Repetitions.wrap(@pullup_reps)
  end

  def band_support?
    @band_support
  end

  def band_factor
    if band_support?
      BAND_FACTOR[band_color] || 1.0
    else
      1.0
    end
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
