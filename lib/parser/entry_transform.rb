class Parser::EntryTransform < Parslet::Transform
  rule(reps: simple(:reps)) { Integer(reps) }
  rule(distance: { m: simple(:m)}) { Distance.new(m, 'm') }
  rule(km: simple(:km)) { Distance.new(km, 'km') }
  rule(comment: simple(:comment)) { Comment.new(comment) }
  rule(tag: simple(:tag)) { Tag.new(tag) }
  rule(pause: {
         min: simple(:min),
         sec: simple(:sec)
       }) do
    Pause.new(min:, sec:)
  end
  rule(
    time: simple(:time),
    workout_name: 'FBSC1',
    pullup_reps: sequence(:pullup_reps),
    notes: subtree(:notes),
    notes2: subtree(:notes2),
  ) do
    FBSCEntry.new(time, 'FBSC1', pullup_reps, notes: Array(notes) + Array(notes2))
  end
  rule(
    time: simple(:time),
    reps: simple(:reps),
    duration_min: simple(:duration),
    level: simple(:level),
    notes: subtree(:notes),
    notes2: subtree(:notes2),
  ) do
    RowEntry.new(time, Integer(duration), Integer(level), reps: reps, notes: Array(notes) + Array(notes2))
  end
  rule(
    workout_name: 'Fahrrad',
    time: simple(:time),
    reps: simple(:reps),
    duration_min: simple(:duration),
    notes: subtree(:notes),
  ) do
    BikeEntry.new(time, duration: duration, reps: reps, notes: notes)
  end
  rule(
    workout_name: 'Fahrrad',
    time: simple(:time),
    distance: simple(:distance),
    notes: subtree(:notes),
  ) do
    BikeEntry.new(time, distance: distance, notes: notes)
  end
  rule(
    time: simple(:time),
    reps: simple(:reps),
    notes: subtree(:notes),
  ) do
    FerengiEntry.new(time, reps: reps, notes: notes)
  end
  rule(
    workout_name: 'SKIP',
    time: simple(:time),
    text: simple(:text),
  ) do
    SkipEntry.new(time, comments: [text])
  end
  rule(
    workout_name: 'ALT',
    time: simple(:time),
    text: simple(:text),
  ) do
    AltEntry.new(time, comments: [text])
  end
  rule(
    time: simple(:time),
    workout_name: simple(:workout_name)
  ) do
    Entry.new(time, workout_name)
  end
end
