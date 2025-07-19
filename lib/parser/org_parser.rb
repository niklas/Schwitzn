class Parser::OrgParser < Parslet::Parser
  # Single Chars
  rule(:newline)  { str("\n") }
  rule(:space)    { match('\s').repeat(1) }
  rule(:space?)   { space.maybe }
  rule(:lt)       { str('<') }
  rule(:gt)       { str('>') }
  rule(:lparen)   { str('(') }
  rule(:rparen)   { str(')') }
  rule(:dash)     { str('-') }
  rule(:colon)    { str(':') }
  rule(:digit)    { match['0-9'] }

  # Things
  rule(:heading)  { str('* Work out') >> newline }
  rule(:org_date) { lt >> iso_date >> space? >> gt }
  rule(:iso_date) { d(4) >> dash >>
                    d(2) >> dash >>
                    d(2) >> space >>
                    weekday >> time.maybe }
  rule(:time)     { space? >> d(2) >> colon >> d(2) }
  rule(:weekday)  { alt(%w(Mon Tue Wed Thu Fri Sat Sun Mo Di Mi Do Fr Sa So)) }
  rule(:pause)    { match('(\d):(\d{2}) Pause')}
  rule(:workout_name) { match['A-Z'].repeat(2) >> digit.maybe }
  rule(:pullup_variant) { str('black band, support')}
  rule(:reps_sequence) { reps >> dash >> reps_sequence | reps  }
  rule(:reps_count) { digit.repeat(1,3) }

  # Grammar parts
  rule(:workout)  { workout_name >> lparen >> pullup_variant >> rparen >> reps_sequence >> lparen >> pause >> rparen}
  rule(:bullets)  { bullet.repeat() }
  rule(:bullet)   { str('-') >> space >> org_date >> workout }
  rule(:org)      { heading.maybe >> bullets }
  root(:org)

  def d(n)
    digit.repeat(n)
  end

  def alt(alts)
    alts.map(&method(:str)).inject(:|)
  end
end
