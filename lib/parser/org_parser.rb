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
  rule(:times)    { str('x') }
  rule(:at)       { str('@') }
  rule(:digit)    { match['0-9'] }
  rule(:uppercase_snake) { match['A-Z_'] }

  # Consumers
  rule(:rest_of_line) { match['^\n'].repeat }
  rule(:empty_line) { match[' '].repeat >> newline }

  # Org stufff
  rule(:org_tags) { org_tag.repeat }
  rule(:org_tag)  { space >> colon >> uppercase_snake.repeat >> colon >> rest_of_line >> newline }

  # Things
  rule(:heading)  { str('* Work out') >> newline }
  rule(:org_date) { lt >> iso_date.as(:time) >> gt }
  rule(:iso_date) { d(4) >> dash >>
                    d(2) >> dash >>
                    d(2) >> space >>
                    weekday >> time.maybe }
  rule(:time)     { space? >> d(2) >> colon >> d(2) }
  rule(:weekday)  { alt(%w(Mon Tue Wed Thu Fri Sat Sun Mo Di Mi Do Fr Sa So)) }
  rule(:pause)    { ( d(1,2) >> colon >> d(2) ).as(:pause) >> str('min Pause') }
  rule(:duration) { d(1,2).as(:duration_min) >> str('min') }
  rule(:distance) { d(1,6).as(:m) >> str('m') }
  rule(:workout_name) { match['A-Z'].repeat(2) >> digit.maybe }
  rule(:pullup_variant) { str('black band, support')}
  rule(:reps_sequence) { (reps_count.as(:reps) >> dash.maybe).repeat(1) }
  rule(:reps_count) { d(1,3) }
  rule(:optional_notes_in_parens) do
    (space >> lparen >> notes >> rparen ).maybe
  end
  rule(:notes)      { (note >> (comma >> space?).maybe).repeat }
  rule(:note)       { pause | tag_name.as(:tag) | distance.as(:distance) | free_comment.as(:comment) }
  rule(:tags)       { (tag >> (comma >> space?).maybe).repeat }
  rule(:tag)        { tag_name.as(:tag) | distance.as(:distance) }
  rule(:tag_name)   { alt(%w(
    heiß
    morning
    techinique
    broke_machine
  ))}
  rule(:row_comments) { (row_comment.as(:comment) >> (comma >> space?).maybe).repeat }
  rule(:row_comment) do
    (d(1,2) >> str('s sprint every ') >> d(1,2) >> str('min')) |
      (d(1) >> str(' straight run Ferengi before'))
  end
  rule(:free_comment) { match['A-Za-z0-9 '].repeat(1) }

  # Grammar parts
  rule(:workout)  { row_workout | bike_workout | complex_workout }

  # 2 x 13min @ 2
  rule(:row_workout) do
    reps_count.as(:reps) >> space >>
      times >> space >> duration >> space >>
      at >> space >> d(1).as(:level) >>
      optional_notes_in_parens.as(:notes) >>
      optional_notes_in_parens.as(:notes2) >>
      newline
  end
  rule(:bike_workout) do
    reps_count.as(:reps) >> space >>
      times >> space >> duration >> space >>
      str('Fahrrad').as(:workout_name) >>
      optional_notes_in_parens.as(:notes) >>
      newline
  end

  rule(:complex_workout)  do
    workout_name.as(:workout_name) >> space >>
      lparen >> pullup_variant.as(:details) >> rparen >> space >>
      reps_sequence.as(:pullup_reps) >>
      optional_notes_in_parens.as(:notes) >>
      newline
  end
  rule(:bullets)  { bullet.as(:entry).repeat() }
  rule(:bullet)   { str('-') >> space >> org_date >> space >> workout }
  rule(:org)      { heading.maybe >> org_tags.maybe >> empty_line.repeat >> bullets }
  root(:org)

  def d(*n)
    digit.repeat(*n)
  end

  def alt(alts)
    alts.map(&method(:str)).inject(:|)
  end
end
