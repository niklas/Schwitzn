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
  end
end
