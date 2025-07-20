class Parser::EntryTransform < Parslet::Transform
  rule(reps: simple(:reps)) { Integer(reps) }
  rule(
    time: simple(:time),
    workout_name: simple(:workout_name),
    pullup_reps: sequence(:pullup_reps),
    details: simple(:details),
    tags: simple(:tags)
  ) do
    FSBCEntry.new(time, workout_name, details, pullup_reps, tags)
  end
  rule(
    time: simple(:time),
    workout_name: simple(:workout_name)
  ) do
    Entry.new(time, workout_name)
  end
end
