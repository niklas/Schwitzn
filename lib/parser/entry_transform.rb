class Parser::EntryTransform < Parslet::Transform
  rule(reps: simple(:reps)) { Integer(reps) }
  rule(distance: { m: simple(:m)}) { Distance.new(m) }
  rule(comment: simple(:comment)) { Comment.new(comment) }
  rule(tag: simple(:tag)) { tag.to_s }
  rule(
    time: simple(:time),
    workout_name: simple(:workout_name),
    pullup_reps: sequence(:pullup_reps),
    details: simple(:details),
    tags: subtree(:tags)
  ) do
    FSBCEntry.new(time, workout_name, details, pullup_reps, tags)
  end
  rule(
    time: simple(:time),
    reps: simple(:reps),
    duration_min: simple(:duration),
    level: simple(:level),
    tags: subtree(:tags),
    comments: subtree(:comments),
  ) do
    RowEntry.new(time, Integer(reps), Integer(duration), Integer(level), tags, nil, comments)
  end
  rule(
    time: simple(:time),
    workout_name: simple(:workout_name)
  ) do
    Entry.new(time, workout_name)
  end
end
