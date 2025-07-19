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
  rule(:comma)    { str(',') }
  rule(:digit)    { match['0-9'] }

  # Things
  rule(:heading)  { str('* Work out') >> newline }
  rule(:org_date) { lt >> iso_date.as(:time) >> gt }
  rule(:iso_date) { d(4) >> dash >>
                    d(2) >> dash >>
                    d(2) >> space >>
                    weekday >> time.maybe }
  rule(:time)     { space? >> d(2) >> colon >> d(2) }
  rule(:weekday)  { alt(%w(Mon Tue Wed Thu Fri Sat Sun Mo Di Mi Do Fr Sa So)) }
  rule(:pause)    { d(1,2) >> colon >> d(2) >> str('min Pause') }
  rule(:workout_name) { match['A-Z'].repeat(2) >> digit.maybe }
  rule(:pullup_variant) { str('black band, support')}
  rule(:reps_sequence) { reps_count >> dash >> reps_sequence | reps_count  }
  rule(:reps_count) { digit.repeat(1,3) }
  rule(:tags)       { (comma >> space? >> tag).repeat }
  rule(:tag)      { alt(%w(heiß))}

  # Grammar parts
  rule(:workout)  { workout_name.as(:workout_name) >> space >>
                    lparen >> pullup_variant.as(:details) >> rparen >> space >>
                    reps_sequence.as(:pullup_reps) >> space >>
                    lparen >> pause >> tags.maybe.as(:tags) >> rparen >> newline
  }
  rule(:bullets)  { bullet.repeat() }
  rule(:bullet)   { str('-') >> space >> org_date >> space >> workout }
  rule(:org)      { heading.maybe >> bullets }
  root(:org)

  def d(*n)
    digit.repeat(*n)
  end

  def alt(alts)
    alts.map(&method(:str)).inject(:|)
  end
end
