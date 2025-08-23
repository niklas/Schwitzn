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

    it 'detects name' do
      expect(entry.name).to eq('FBSC1')
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
- <2022-11-24 Do> SKIP - Weihnachtsfeier, dann krank
- <2023-03-13 Mon> FBSC1 (chinup, last round total fail, aborted) 5-2-1-0
- <2023-03-23 Thu> FBSC1 (rings) 8-8-8-8
- <2023-04-24 Mon> ALT - Frau Zeug hochtragen
- <2024-07-13 Sat> 35km Fahrrad (heim aus Finkenkrug)
- <2024-09-01 Sun 22:10> BACK1
- <2024-09-04 Wed 14:00> FBSC1 (black band, support) 8-8-8-7 (2:45min Pause, heiß)
- <2024-11-12 Tue 20:21> HB1
  Bankdrücken 3*24 @5.5kg
  Flys 3x12 @2.5kg
  Bizeps Curls 3x12 @5.5kg
  Reverse Flys 3x12 @2.5kg
  Trizepsdrücken 3x12 @4kg
  Negatives Bankdrücken 3*12 @5.5kg
  Zehenspitzen 3x24 BW
  Zehenziehen 2x12 rotes Band
  norwegian squats 3x12 @5kg
      EOORG
    end

    let(:expected_entries) do
      [
        RowEntry.new(13, 2, time: '2022-03-22', reps: 2),
        RowEntry.new(10, 2, time: '2022-04-30', reps: 1, tags: %w(morning)),
        RowEntry.new( 6, 3, time: '2022-09-10', reps: 2, distance: 1500),
        RowEntry.new( 6, 3, time: '2022-09-15', reps: 3, distance: 2300, comments: ['30s sprint every 2min']),
        RowEntry.new( 6, 3, time: '2022-10-22', reps: 3, distance: 2420, comments: ['30s sprint every 2min', '2 straight run Ferengi before']),
        BikeEntry.new(time: '2022-10-26', duration: 60, reps: 2, comments: ['Lena']),
        FerengiEntry.new(time: '2022-11-22', reps: 1, comments: ['kein Rudern', 'Schultern schmerzen']),
        SkipEntry.new(time: '2022-11-24', comments: ['Weihnachtsfeier, dann krank']),
        FBSCEntry.new(time: '2023-03-13', name: 'FBSC1', pullup_reps: [5, 2, 1, 0], comments: ['last round total fail'], tags: %w(chinup aborted)),
        FBSCEntry.new(time: '2023-03-23', name: 'FBSC1', pullup_reps: [8, 8, 8, 8], tags: %w(rings)),
        AltEntry.new(time: '2023-04-24', comments: ['Frau Zeug hochtragen']),
        BikeEntry.new(time: '2024-07-13', distance: 35000, comments: ['heim aus Finkenkrug']),
        NamedWorkout.new(time: '2024-09-01Z22:10', name: 'BACK1'),
        FBSCEntry.new(time: '2024-09-04Z14:00', name: 'FBSC1', pullup_reps: [8, 8, 8, 7], comments: ['black band', 'support'], tags: ['heiß'], pause: Pause.new(min: 2, sec: 45)),
        Exercise.new(time: '2024-11-12Z20:21', name: 'Bankdrücken', sets: 3, reps: 24, weight: 5.5),
        Exercise.new(time: '2024-11-12Z20:21', name: 'Flys',        sets: 3, reps: 12, weight: 2.5),
        Exercise.new(time: '2024-11-12Z20:21', name: 'Bizeps Curls', sets: 3, reps: 12, weight: 5.5),
        Exercise.new(time: '2024-11-12Z20:21', name: 'Reverse Flys', sets: 3, reps: 12, weight: 2.5),
        Exercise.new(time: '2024-11-12Z20:21', name: 'Trizepsdrücken', sets: 3, reps: 12, weight: 4),
        Exercise.new(time: '2024-11-12Z20:21', name: 'Negatives Bankdrücken', sets: 3, reps: 12, weight: 5.5),
        Exercise.new(time: '2024-11-12Z20:21', name: 'Zehenspitzen', sets: 3, reps: 24, comments: %w(BW)),
        Exercise.new(time: '2024-11-12Z20:21', name: 'Zehenziehen', sets: 2, reps: 12, comments: ['rotes Band']),
        Exercise.new(time: '2024-11-12Z20:21', name: 'norwegian squats', sets: 3, reps: 12, weight: 5),
      ]
    end


    it "finds all entries" do
      expect(entries).to eq(expected_entries)
    end
  end
end
