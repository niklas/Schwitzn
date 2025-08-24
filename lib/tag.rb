class Tag < String
  ALL = %w(
    heiß
    morning
    technique
    krank
    broke_machine
    chinup
    aborted
    rings
    time
    almost
    nogrip
    sim
    badform-left
    support
    lazy
  ).freeze

  ICONS = {
    'heiß'          => '☀️',
    'morning'       => '🌅',
    'technique'     => '🥋',
    'krank'         => '⚕️',
    'broke_machine' => '❇️️',
    'chinup'        => '🤷',
    'aborted'       => '🚫',
    'rings'         => '➿',
    'time'          => '⏱️',
    'almost'        => '🤏️',
    'nogrip'        => '👏️',
    'sim'           => '️♒',
    'badform-left'  => '🫳',
    'support'       => '🪑',
    'lazy'          => '🛋️',
  }.freeze

  def initialize(name)
    raise ArgumentError.new("unknown tag: #{name}") unless ALL.include?(name)
    super
  end

  def icon
    ICONS.fetch(to_s) { self }
  end
end
