describe Exercise do
  let(:e) do
    described_class.new(
      time: '2015-07-02Z13:30',
      name: 'Eier schaukeln',
      sets: 3,
      reps: 20,
      weight: 2,
      tags: ['lazy'],
      comments: [pure_comment],
    )
  end
  let(:pure_comment) { 'alien invasion' }
  let(:comment) { Comment.new(pure_comment)}

  it 'knows its attribute names' do
    expect(described_class.attribute_names.sort).to eq([
                                                         :time,
                                                         :name,
                                                         :sets,
                                                         :reps,
                                                         :weight,
                                                         :comments,
                                                         :tags
                                                       ].sort)
  end

  it 'stores time' do
    expect(e.time).to eq(Time.new(2015,7,2,13,30))
  end

  it 'stores name' do
    expect(e.name).to eq('Eier schaukeln')
  end

  it 'stores sets' do
    expect(e.sets).to eq(3)
  end

  it 'stores reps' do
    expect(e.reps).to eq(20)
  end

  it 'stores weight' do
    expect(e.weight).to eq(Weight.new(2, 'kg'))
  end

  it 'converts and stores comments' do
    expect(e.comments).to eq([comment])
  end

  it 'converts and stores tags' do
    expect(e.tags).to eq([Tag.new('lazy')])
  end
end
