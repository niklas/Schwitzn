describe FBSCEntry do
  describe 'on a hot day with black band support and a pause' do
    let(:e) do
      FBSCEntry.new(
        time: '2024-09-04Z14:00',
        name: 'FBSC1',
        pullup_reps: [8, 8, 8, 7],
        comments: ['black band'],
        tags: ['heiß', 'support'],
        pause: Pause.new(min: 2, sec: 45)
      )
    end

    it 'has name' do
      expect(e.name).to eq('FBSC1')
    end

    it 'has tags' do
      expect(e.tags).to eq(%w(heiß support))
    end

    it 'has details' do
      expect(e.details).to eq(['black band'])
    end

    it 'has colored black' do
      expect(e.color_in_set(1,4)).to eq('rgba(10,10,10,1)')
    end

    it 'knows I needed support by band' do
      expect(e).to be_band_support
    end

    it 'has reps' do
      expect(e.reps.to_a).to eq([8, 8, 8, 7])
    end
  end
end
