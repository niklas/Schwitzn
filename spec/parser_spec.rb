describe Parser do
  let(:org) { '' }
  let(:entry) { entries.first }
  let(:entries) { described_class.new(org).entries }

  describe '#parse FSBC' do
    let(:org) do
      <<EOORG
- <2024-09-04 Wed 14:00> FBSC1 (black band, support) 8-8-8-7 (2:45min Pause, heiß)
EOORG
    end

    it 'detects time' do
      expect(entry.time).to eq(Time.new(2024, 9, 4, 14, 0))
    end

    it 'detects workout_name' do
      expect(entry.workout_name).to eq('FBSC1')
    end

    it 'detects details' do
      expect(entry.details).to eq('black band, support')
    end

    it 'detects band color' do
      expect(entry.band_color).to eq('black')
    end

    it 'detects if support or not' do
      expect(entry).to be_band_support
    end

    it 'detects pullup_reps' do
      expect(entry.pullup_reps).to eq([8, 8, 8, 7])
    end
  end

  describe '#parse whole org' do
    let(:org) do
      <<-EOORG
* Work out
  :PROPERTIES:
  :LAST_REPEAT: [2024-02-12 Mon 02:46]
  :END:

- <2022-03-22 Tue> 2 x 13min @ 2
- <2022-04-30 Sat> 1 x 10min @ 2 (morning)
      EOORG
    end

    let(:expected_entries) do
      [
        RowEntry.new('2022-03-22', 2, 13, 2),
        RowEntry.new('2022-04-30', 1, 10, 2, %w(morning)),
      ]
    end


    it "finds all entries" do
      expect(entries).to eq(expected_entries)
    end
  end
end
