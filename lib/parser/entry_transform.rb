class Parser::EntryTransform < Parslet::Transform
  rule(reps: simple(:reps), sets: simple(:reps)) { Repetitions.wrap(sets, reps) }
  rule(reps: sequence(:reps)) { Repetitions.wrap(reps) }
  rule(reps: simple(:reps)) { Repetitions.wrap(reps) }
  rule(distance: { m: simple(:m)}) { Distance.new(m, 'm') }
  rule(km: simple(:km)) { Distance.new(km, 'km') }
  rule(kg: simple(:kg), times: simple(:times)) { Weight.new(kg, 'kg', times) }
  rule(kg: simple(:kg)) { Weight.new(kg, 'kg') }
  rule(duration_s: simple(:s)) { Duration.new(s, 's') }
  rule(duration_min: simple(:min)) { Duration.new(min, 'min') }
  rule(comment: simple(:comment)) { Comment.new(comment) }
  rule(tag: simple(:tag)) { Tag.new(tag) }
  rule(pause: {
         min: simple(:min),
         sec: simple(:sec)
       }) do
    Pause.new(min:, sec:)
  end
  rule(
    remark: simple(:remark),
    time: simple(:time)
  ) do
    Remark.new(time: time, comment: remark)
  end
  rule(
    time: simple(:time),
    workout_name: 'FBSC1',
    pullup_reps: sequence(:pullup_reps),
    notes: subtree(:notes),
    notes2: subtree(:notes2),
  ) do
    FBSCEntry.new(time: time, name: 'FBSC1', pullup_reps: pullup_reps, notes: Array(notes) + Array(notes2))
  end
  rule(
    time: simple(:time),
    reps: simple(:reps),
    duration_min: simple(:duration),
    level: simple(:level),
    notes: subtree(:notes),
    notes2: subtree(:notes2),
  ) do
    RowEntry.new(Integer(duration), Integer(level), time: time, reps: reps, notes: Array(notes) + Array(notes2))
  end
  rule(
    workout_name: 'Fahrrad',
    time: simple(:time),
    reps: simple(:reps),
    duration_min: simple(:duration),
    notes: subtree(:notes),
  ) do
    BikeEntry.new(time: time, duration: duration, reps: reps, notes: notes)
  end
  rule(
    workout_name: 'Fahrrad',
    time: simple(:time),
    distance: simple(:distance),
    notes: subtree(:notes),
  ) do
    BikeEntry.new(time: time, distance: distance, notes: notes)
  end
  rule(
    time: simple(:time),
    reps: simple(:reps),
    notes: subtree(:notes),
  ) do
    FerengiEntry.new(time: time, reps: reps, notes: notes)
  end
  rule(
    workout_name: 'SKIP',
    time: simple(:time),
    text: simple(:text),
  ) do
    SkipEntry.new(time: time, comments: [text])
  end
  rule(
    workout_name: 'ALT',
    time: simple(:time),
    text: simple(:text),
  ) do
    AltEntry.new(time: time, comments: [text])
  end
  rule(
    name: simple(:name),
    repetitions: subtree(:repetitions),
    weight: simple(:weight),
    notes: subtree(:notes),
  ) do
    Exercise.new(time: :parent, name: name, reps: repetitions, weight: weight, notes: notes)
  end
  rule(
    name: simple(:name),
    repetitions: subtree(:repetitions),
    notes: subtree(:notes),
  ) do
    Exercise.new(time: :parent, name: name, reps: repetitions, notes: notes)
  end
  rule(
    name: simple(:name),
    repetitions: subtree(:repetitions),
    weight: simple(:weight),
    notes: subtree(:notes),
  ) do
    Exercise.new(time: :parent, name: name, reps: repetitions, weight: weight, notes: notes)
  end
  rule(
    name: simple(:name),
    weight: simple(:weight),
    notes: subtree(:notes),
  ) do
    Exercise.new(time: :parent, name: name, reps: 1, weight: weight, notes: notes)
  end
  rule(
    time: simple(:time),
    workout_name: simple(:workout_name),
    exercises: sequence(:exercises),
  ) do
    DetailedWorkout.new(time: time, name: workout_name, exercises: exercises)
  end
  rule(
    time: simple(:time),
    duration: simple(:duration),
    workout_name: simple(:workout_name)
  ) do
    NamedWorkout.new(time: time, name: workout_name, duration: duration)
  end
  rule(
    time: simple(:time),
    workout_name: simple(:workout_name)
  ) do
    NamedWorkout.new(time: time, name: workout_name)
  end
end
