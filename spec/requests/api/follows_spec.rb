RSpec.describe "Follow API" do
  include_context 'when user exists'

  let!(:follower) { User.create(name: "follower", handle: "follower", email: "follower@toptal.com") }

  describe "POST /api/users/:user_id/follows" do
    subject(:result) do
      post "/api/users/#{user_id}/follows", params: valid_params 
      response
    end

    context 'when the request is valid' do
      let!(:valid_params) { { follow: { follower_id: follower.id } } }

      it { expect(result).to have_http_status(200) }

      it 'creates a new follow' do
        expect { result }.to change(Follow, :count).by(1)
      end 

      it 'responds with correct data' do
        expect(JSON.parse(result.body)).to include(hash_including("name"=>"follower", "handle"=>"follower","email"=>"follower@toptal.com"))
      end
    end

    context 'when the request is invalid' do
      before { post "/api/users/#{user_id}/follows", params: { follow: { follower_id: 0 } } }

      it { expect(response).to have_http_status(404) }

      it 'returns a failure message' do
        expect(JSON.parse(response.body)).to match({"error"=>"Couldn't find User with 'id'=0"}) 
      end

      it 'does not create a follow' do
        expect { response }.not_to change(Follow, :count)
      end
    end

    context 'when user does not exist' do
      let!(:valid_params) { { follow: { follower_id: follower.id } } }

      include_examples 'user does not exist'
    end
  end

  describe 'DELETE /api/users/:user_id/follows/:id' do
    let!(:follow) { Follow.create(user_id: user.id, follower_id: follower.id) }
    let!(:follow_id) { follow.id }
    let!(:result) { delete "/api/users/#{user_id}/follows/#{follow_id}"; response }

    context 'when user exists' do
      let(:user_id) { user.id }

      specify { expect(result).to have_http_status(204) }

      context 'when follow does not exist' do
        let!(:follow_id) { 0 }

        it { expect(result).to have_http_status(404) }

        it 'returns a not found message' do 
          expect(JSON.parse(result.body)).to eq("error" => "Couldn't find Follow with 'id'=0")
        end
      end
    end

    context 'when user does not exist' do
      include_examples 'user does not exist'
    end
  end
end
