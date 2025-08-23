class Parser::OrgParser < Parslet::Parser
  # Single Chars
  rule(:newline)  { str("\n") }
  rule(:space)    { match(' ').repeat(1) }
  rule(:space?)   { space.maybe }
  rule(:wspace)   { match('\s').repeat(1) }
  rule(:lt)       { str('<') }
  rule(:gt)       { str('>') }
  rule(:lparen)   { str('(') }
  rule(:rparen)   { str(')') }
  rule(:dash)     { str('-') }
  rule(:colon)    { str(':') }
  rule(:comma)    { str(',') }
  rule(:dot)      { str('.') }
  rule(:times)    { str('x') | str('*') }
  rule(:at)       { str('@') }
  rule(:digit)    { match['0-9'] }
  rule(:uppercase_snake) { match['A-Z_'] }
  rule(:letter)   { match['A-Za-zäöüÄÖÜß'] }
  rule(:word)      { space? >> letter.repeat(2) }

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
  rule(:pause)    { ( d(1,2).as(:min) >> colon >> d(2).as(:sec) ).as(:pause) >> str('min Pause') }
  rule(:duration) { d(1,2).as(:duration_min) >> str('min') }
  rule(:distance) { distance_m | distance_km }
  rule(:distance_m) { d(1,6).as(:m) >> str('m') }
  rule(:distance_km) { d(1,6).as(:km) >> str('km') }
  rule(:weight)     { at >> (d(1,2) >> (dot >> d(1,2)).maybe).as(:kg) >> str('kg')}
  rule(:sets_x_reps) { d(1,1).as(:sets) >> times >> d(1,2).as(:reps) }
  rule(:workout_name) { match['A-Z'].repeat(2) >> digit.maybe }
  rule(:exercise_name) { word.repeat(1) }
  rule(:reps_sequence) { (reps_count.as(:reps) >> dash.maybe).repeat(1) }
  rule(:reps_count) { d(1,3) }
  rule(:optional_notes_in_parens) do
    (space >> lparen >> notes >> rparen ).maybe
  end
  rule(:notes)      { (note >> (comma >> space?).maybe).repeat }
  rule(:note)       { pause | tag_name.as(:tag) | distance.as(:distance) | free_comment.as(:comment) }
  rule(:tags)       { (tag >> (comma >> space?).maybe).repeat }
  rule(:tag)        { tag_name.as(:tag) | distance.as(:distance) }
  rule(:tag_name)   { alt(Tag::ALL) }
  rule(:row_comments) { (row_comment.as(:comment) >> (comma >> space?).maybe).repeat }
  rule(:row_comment) do
    (d(1,2) >> str('s sprint every ') >> d(1,2) >> str('min')) |
      (d(1) >> str(' straight run Ferengi before'))
  end
  rule(:free_comment) { match['A-Za-z0-9ÄÖÜäöüß: '].repeat(1) }

  # Grammar parts
  rule(:workout) do
    row_workout |
      bike_workout |
      bike_distance_workout |
      ferengi_workout |
      fbsc_workout |
      detailed_workout |
      named_workout |
      no_workout
  end

  # 2 x 13min @ 2
  rule(:row_workout) do
    reps_count.as(:reps) >> space >>
      times >> space >> duration >> space >>
      at >> space >> d(1).as(:level) >>
      optional_notes_in_parens.as(:notes) >>
      optional_notes_in_parens.as(:notes2)
  end
  rule(:detailed_workout) do
    alt(DetailedWorkout::NAMES).as(:workout_name) >>
      (newline >> exercise).repeat(3).as(:exercises)
  end
  rule(:named_workout) do
    alt(NamedWorkout::NAMES).as(:workout_name)
  end
  rule(:bike_workout) do
    reps_count.as(:reps) >> space >>
      times >> space >> duration >> space >>
      str('Fahrrad').as(:workout_name) >>
      optional_notes_in_parens.as(:notes)
  end
  rule(:bike_distance_workout) do
    distance.as(:distance) >> space >>
      str('Fahrrad').as(:workout_name) >>
      optional_notes_in_parens.as(:notes)
  end
  rule(:ferengi_workout) do
    reps_count.as(:reps) >> space >>
      (str('straight Ferengi') | str('straight run Ferengi')) >>
      optional_notes_in_parens.as(:notes)
  end
  rule(:no_workout) do
    (str('SKIP') | str('ALT')).as(:workout_name) >>
      str(' -') >> space >>
      rest_of_line.as(:text)
  end

  rule(:fbsc_workout)  do
    workout_name.as(:workout_name) >>
      optional_notes_in_parens.as(:notes2) >>
      space? >>
      reps_sequence.as(:pullup_reps) >>
      optional_notes_in_parens.as(:notes)
  end
  rule(:exercise) do
    space >>
      exercise_name.as(:name) >> space >>
      sets_x_reps >> space? >>
      weight.as(:weight).maybe >>
      space? >> notes.maybe.as(:notes)
  end
  rule(:bullets)  { bullet.as(:entry).repeat() }
  rule(:bullet)   { str('-') >> space >> org_date >> space >> workout >> newline }
  rule(:org)      { heading.maybe >> org_tags.maybe >> empty_line.repeat >> bullets }
  root(:org)

  def d(*n)
    digit.repeat(*n)
  end

  def alt(alts)
    alts.map(&method(:str)).inject(:|)
  end
end
