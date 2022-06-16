RSpec.describe Follow, type: :model do
  describe 'validations' do
    let!(:first_user) { User.create(name: "first", handle: "first", email: "first@toptal.com") }
    let!(:second_user) { User.create(name: "second", handle: "second", email: "second@toptal.com") }
    let!(:follow) { Follow.create(user_id: first_user.id, follower_id: second_user.id) }

    it { is_expected.to validate_presence_of(:user_id) }
    it { is_expected.to validate_presence_of(:follower_id) }
    it { is_expected.to validate_uniqueness_of(:follower_id).scoped_to(:user_id) }
  end

  describe 'associations' do
    it { is_expected.to belong_to(:user) }
    it { is_expected.to belong_to(:follower) } 
  end
end
