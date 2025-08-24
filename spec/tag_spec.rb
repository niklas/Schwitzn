describe Tag do
  describe 'all' do
    described_class::ALL.each do |name|
      describe "#{name}" do
        let(:tag) { Tag.new(name) }
        it "has icon" do
          expect(tag.icon).to_not eq(tag)
        end
      end
    end
  end
end
