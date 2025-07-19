class Parser::EntryTransform < Parslet::Transform
  rule(time: simple(:time), workout_name: simple(:workout_name)) do
    Entry.new(time, workout_name)
  end
end
