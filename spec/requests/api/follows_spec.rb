RSpec.describe "Follow API" do
  let!(:user) { User.create(name: "Macarena", handle: "mapeciris", email: "macarena@toptal.com") }
  let!(:follower) { User.create(name: "follower", handle: "follower", email: "follower@toptal.com") }

  describe "POST /api/users/:user_id/follows" do
    subject(:result) do
      post "/users/#{user.id}/follows", params: valid_params 
      response
    end

    context 'when the request is valid' do
      let!(:valid_params) { { follow: { follower_id: follower.id } } }

      it { expect(response).to have_http_status(201) }

      it 'creates a new follow' do
        expect { result }.to change(Follow, :count).by(1)
      end
  
      it 'adds a follower to user' do
        expect(user.followers).to include(follower)
      end
    end

    context 'when the request is invalid' do
      let!(:params) { { follow: {} } }

      it { is_expected.to have_http_status(422) }

      it 'returns a failure message' do
        expect(JSON.parse(response.body)).to match({"follower_id"=>["can't be blank"]}) 
      end
    end
  end

  describe 'DELETE /api/users/:user_id/follows/:id' do
    let!(:follow) { Follow.create(user_id: user.id, follower_id: follower.id) }

    before { delete "/api/users/#{user.id}/follows/#{follow.id}" }

    specify { expect(response).to have_http_status(204) }
  end
end
