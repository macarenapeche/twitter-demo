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

  describe "scopes" do
    include_context "when user exists"
    include_context "when tweet exists"
    let!(:dog) { User.create(name: "Tokyo", handle: "iamadog", email: "doggie@gmail.com") }
  
    describe ".handle_starting_by" do
      it "includes users with handle starting with given expression" do
        str = "ma"
        expect(User.handle_starting_by(str)).to include(user)
      end
  
      it "excludes users with handle not starting with given expression" do
        str = "vo"
        expect(User.handle_starting_by(str)).not_to include(user)
      end
    end
  
    describe ".with_tweets" do
      it "includes users with tweets" do
        expect(User.with_tweets).to include(user)
      end
  
      it "excludes users without tweets" do
        expect(User.with_tweets).not_to include(dog)
      end
    end
  
    describe ".without_tweets" do
      it "includes users without tweets" do
        expect(User.without_tweets).to include(dog)
      end
  
      it "excludes users with tweets" do
        expect(User.without_tweets).not_to include(user)
      end
    end
  
    describe ".other_than" do
      it "includes users with id different a given one" do
        expect(User.other_than(1)).to include(dog)
      end
  
      it "excludes user with a given id" do
        expect(User.other_than(1)).not_to include(user)
      end
    end
  end

end
