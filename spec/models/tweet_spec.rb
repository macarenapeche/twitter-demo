RSpec.describe Tweet, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:content) }
    it { should validate_length_of(:content).is_at_most(280) }
  end

  describe 'associations' do
    it { should belong_to(:user) }
    it { should have_many(:likes) }
  end
end
