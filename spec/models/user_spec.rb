RSpec.describe User, type: :model do
  describe 'validations' do
    subject(:user) { User.new(name: "Macarena", handle: "mapeciris", email: "mapeciris@gmail.com", bio: "") }

    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:handle) }
    it { is_expected.to validate_presence_of(:email) }
    it { is_expected.to validate_uniqueness_of(:handle) }
    it { is_expected.to validate_uniqueness_of(:email) }
    it { is_expected.to allow_value("a@gmail.com").for(:email) }
    it { is_expected.to_not allow_value("gibberish").for(:email) }
    it { is_expected.to allow_value("Fa-9gr").for(:handle) }
    it { is_expected.to_not allow_value('@&$·n').for(:handle) }
  end

  describe 'associations' do
    it { is_expected.to have_many(:tweets) }
    it { is_expected.to have_many(:likes) } 
    # describe the follow association once is fixed
  end 

end
