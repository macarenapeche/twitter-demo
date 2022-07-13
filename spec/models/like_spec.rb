RSpec.describe Like, type: :model do
  describe 'validations' do
    include_context 'when user exists'
    include_context 'when tweet exists'
    let!(:second_user) { User.create(name: "second", handle: "second", email: "second@toptal.com", password: "password") }
    let!(:like) { Like.create(user_id: second_user.id, tweet_id: tweet.id) }
    it { is_expected.to validate_presence_of(:user_id) }
    it { is_expected.to validate_presence_of(:tweet_id) }
    it { is_expected.to validate_uniqueness_of(:user_id).scoped_to(:tweet_id).with_message("already liked this tweet") }
  end

  describe 'associations' do
    it { is_expected.to belong_to(:user) }
    it { is_expected.to belong_to(:tweet) } 
  end
end
