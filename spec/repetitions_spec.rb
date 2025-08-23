describe Repetitions do
  describe '42' do
    let(:r) { described_class.wrap(42) }
    it 'totals to 42' do
      expect(r.total).to eq(42)
    end
    it 'looks good' do
      expect(r.inspect).to eq('42')
    end
  end

  describe '5x12' do
    let(:r) { described_class.wrap(5, 12) }
    it 'totals to 60' do
      expect(r.total).to eq(60)
    end
    it 'looks good' do
      expect(r.inspect).to eq('5x12')
    end
  end

  describe '8-6-3' do
    let(:r) { described_class.wrap([8,6,3]) }
    it 'totals to 17' do
      expect(r.total).to eq(17)
    end
    it 'looks good' do
      expect(r.inspect).to eq('8-6-3')
    end
  end
end
