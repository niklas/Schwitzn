require 'entry'

class FSBCEntry < Entry
  attr_reader :comment

  def initialize(time, workout_name, details, num_sets, comment)
    super(time, workout_name)

    @details = details
    @num_sets = num_sets.split('-').map(&:to_i)
    @comment = comment
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
end
