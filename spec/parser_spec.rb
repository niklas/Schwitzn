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

    it 'detects workout_name' do
      expect(entry.workout_name).to eq('FBSC1')
    end

    it 'detects details' do
      expect(entry.details).to eq(['black band', 'support'])
    end

    it 'detects band color' do
      expect(entry.band_color).to eq('black')
    end

    it 'detects if support or not' do
      expect(entry).to be_band_support
    end

    it 'inspects' do
      expect(entry.inspect).to match(/^<FBSCEntry @time=/)
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
- <2022-09-10 Sat> 2 x 6min @ 3 (1500m)
- <2022-09-15 Thu> 3 x 6min @ 3 (2300m) (30s sprint every 2min)
- <2022-10-22 Sat> 3 x 6min @ 3 (2420m) (30s sprint every 2min, 2 straight run Ferengi before)
- <2022-10-26 Wed> 2 x 60min Fahrrad (Lena)
- <2022-11-22 Tue> 1 straight Ferengi (kein Rudern, Schultern schmerzen)
- <2022-11-24 Do> NO - Weihnachtsfeier, dann krank
- <2023-03-13 Mon> FBSC1 (chinup, last round total fail, aborted) 5-2-1-0
- <2024-09-04 Wed 14:00> FBSC1 (black band, support) 8-8-8-7 (2:45min Pause, heiß)
      EOORG
    end

    let(:expected_entries) do
      [
        RowEntry.new('2022-03-22', 13, 2, reps: 2),
        RowEntry.new('2022-04-30', 10, 2, reps: 1, tags: %w(morning)),
        RowEntry.new('2022-09-10', 6, 3, reps: 2, distance: 1500),
        RowEntry.new('2022-09-15', 6, 3, reps: 3, distance: 2300, comments: ['30s sprint every 2min']),
        RowEntry.new('2022-10-22', 6, 3, reps: 3, distance: 2420, comments: ['30s sprint every 2min', '2 straight run Ferengi before']),
        BikeEntry.new('2022-10-26', Duration.new(60, 'min'), reps: 2, comments: ['Lena']),
        FerengiEntry.new('2022-11-22', reps: 1, comments: ['kein Rudern', 'Schultern schmerzen']),
        NoEntry.new('2022-11-24', comments: ['Weihnachtsfeier, dann krank']),
        FBSCEntry.new('2023-03-13', 'FBSC1', [5, 2, 1, 0], comments: ['last round total fail'], tags: %w(chinup aborted)),
        FBSCEntry.new('2024-09-04Z14:00', 'FBSC1', [8, 8, 8, 7], comments: ['black band', 'support'], tags: ['heiß'], pause: Pause.new(min: 2, sec: 45)),
      ]
    end


    it "finds all entries" do
      expect(entries).to eq(expected_entries)
    end
  end
end
