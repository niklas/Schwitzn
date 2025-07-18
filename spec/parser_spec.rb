describe Parser do
  let(:org) { '' }
  let(:entry) { described_class.new(org).entries.first }

  describe '#parse FSBC' do
    let(:org) do
      <<EOORG
- <2024-09-04 Wed 14:00> FBSC1 (black band, support) 8-8-8-7 (2:45min Pause, heiß)
EOORG
    end

    it 'detects time' do
      expect(entry.time).to eq(Time.new(2024,9,4,14,00))
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
end
