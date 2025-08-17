describe Entry do
  it 'needs a date' do
    e = described_class.new('2001-09-11')
    expect(e).to_not be_nil
  end

  it 'knows its attribute names' do
    expect(described_class.attribute_names).to eq([:time, :workout_name])
  end

  describe 'subclasses' do
    describe RowEntry do
      it 'knows its attribute names' do
        expect(described_class.attribute_names).to eq([:time, :workout_name, :comments, :distance, :tags, :reps, :duration, :level])
      end
    end

    describe BikeEntry do
      it 'knows its attribute names' do
        expect(described_class.attribute_names).to eq([:time, :workout_name, :comments, :distance, :tags, :reps, :duration])
      end
    end
  end
end
