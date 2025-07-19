class Parser::OrgParser < Parslet::Parser
  # Single Chars
  rule(:newline)  { str("\n") }
  rule(:space)    { match('\s').repeat(1) }
  rule(:space?)   { space.maybe }
  rule(:lt)       { str('<') }
  rule(:gt)       { str('>') }
  rule(:lparen)   { str('(') }
  rule(:rparen)   { str(')') }

  # Things
  rule(:heading)  { str('* Work out') >> newline }
  rule(:org_date) { lt >> iso_date >> space? >> gt }
  rule(:iso_date) { match('(\d{4})-(\d{2})-(\d{2})') >> space? >> weekday >> time.maybe }
  rule(:time)     { space? >> match('(\d{2}):(\d{2})') }
  rule(:weekday)  { match('Mon|Tue|Wed|Thu|Fri|Sat|Sun|Mo|Di|Mi|Do|Fr|Sa|So') }
  rule(:pause)    { match('(\d):(\d{2}) Pause')}

  # Grammar parts
  rule(:workout)  { workout_name >> lparen >> pullup_variant >> rparen >> repetitions_sequence >> lparen >> pause >> rparen}
  rule(:bullets)  { bullet.repeat() }
  rule(:bullet)   { str('-') >> space >> org_date >> workout }
  rule(:org)      { heading.maybe >> bullets }
  root(:org)
end
