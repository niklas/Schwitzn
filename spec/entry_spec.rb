describe Entry do
  it 'needs a date' do
    e = described_class.new('2001-09-11')
    expect(e).to_not be_nil
  end
end
