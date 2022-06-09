RSpec.describe User, type: :model do
  describe 'validations' do
    subject(:user) { User.create(name: "Macarena", handle: "mapeciris", email: "mapeciris@gmail.com", bio: "") }

    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:handle) }
    it { should validate_presence_of(:email) }
    it { should validate_uniqueness_of(:handle) }
    it { should validate_uniqueness_of(:email) }
    it { should allow_value("a@gmail.com").for(:email) }
    it { should_not allow_value("gibberish").for(:email) }
    it { should allow_value("Fa-9gr").for(:handle) }
    it { should_not allow_value('@&$·n').for(:handle) }
  end

  describe 'associations' do
    it { should have_many(:tweets) }
    it { should have_many(:likes) } 
    # describe the follow association once is fixed
  end 

end
