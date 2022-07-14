# UPDATE: DONE (changing shared_context and shared_examples to spec/support). REVIEW: This requires might be done from spec_helper. Something for you to research on your own ;)

RSpec.describe 'Users API', type: :request do
  describe 'GET /api/users' do
    subject(:result) do
      get '/api/users'
      response
    end

    it { is_expected.to have_http_status(200) }

    specify { expect(JSON.parse(result.body)).to eq([]) }

    context 'when has users' do
      include_context "when user exists"
      let(:json) { JSON.parse(result.body) }

      # it { expect(json).not_to be_empty }
      
      # UPDATE: DONE. REVIEW: If the lower spec works, the upper will work always so it's not that necessary
      it { expect(json).to match([
        hash_including("name" => "Macarena", "handle" => "mapeciris", "email" => "macarena@toptal.com")
        ]) }
    end
  end

  describe  'POST /api/users' do
    subject(:result) do
      post '/api/users', params: valid_params, headers: headers
      response
    end

    context "when user is logged in" do
      include_context "when user exists" 
      let(:valid_params) {{ user: { name: "Macarena", handle: "mapeciris", email: "macarena@toptal.com", password: "password" } }}
      let(:headers) { { "Authorization": token } }
      let!(:token) { Api::JsonWebToken.encode(user_id: user.id) }

      it { is_expected.to have_http_status(401) }

      it "returns an error" do
        expect(JSON.parse(result.body)).to eq({
          "errors" => "Users cannot be created while logged in"
        })
      end
    end

    context 'when the request is valid' do
      let(:valid_params) {{ user: { name: "Macarena", handle: "mapeciris", email: "macarena@toptal.com", password: "password" } }}

      it { is_expected.to have_http_status(201) }

      # UPDATE: DONE. REVIEW: Check the response body
      it 'creates an user' do
        expect { result }.to change(User, :count).by(1)
      end

      it 'responds with correct data' do
        expect(JSON.parse(result.body)['id']).to eq(1)
        expect(JSON.parse(result.body)['name']).to eq("Macarena")
        expect(JSON.parse(result.body)['handle']).to eq("mapeciris")
        expect(JSON.parse(result.body)['email']).to eq("macarena@toptal.com")
        expect(JSON.parse(result.body)['bio']).to eq(nil)
      end
    end

    context 'when the request is invalid' do
      before { post '/api/users', params: { user: {name: ""}} }

      specify { expect(response).to have_http_status(422) }

      it 'returns a failure message' do
        expect(JSON.parse(response.body)).to match({
          "name"=>["can't be blank"],
          "handle"=>["can't be blank", "is invalid"],
          "email"=>["can't be blank", "is invalid"],
          "password"=>["can't be blank"]
        }) 
      end

      # UPDATE: DONE. REVIEW: might make sense to check `not_to change(User, :count)` as well, to check behavior AND the response
      it 'does not create an user' do
        expect { response }.not_to change(User, :count)
      end
    end
  end

  describe 'GET /api/users/:id' do
    subject(:result) do
      get "/api/users/#{user_id}"
      response
    end

    context 'when user exists' do
      include_context 'when user exists'

      it { is_expected.to have_http_status(200) }

      it 'responds with correct data' do
        expect(JSON.parse(result.body)['id']).to eq(user_id)
        expect(JSON.parse(result.body)['name']).to eq("Macarena")
        expect(JSON.parse(result.body)['handle']).to eq("mapeciris")
        expect(JSON.parse(result.body)['email']).to eq("macarena@toptal.com")
        expect(JSON.parse(result.body)['bio']).to eq(nil)
      end
    end

    context 'when user does not exist' do
      include_examples 'user does not exist'
    end
  end

  describe 'PUT /api/users/:id' do
    include_context 'when user exists'

    subject(:result) do
      put "/api/users/#{user_id}", params: { user: { name: "Macarena Peche" } }, headers: { "Authorization": token }
      response
    end
    let!(:token) { Api::JsonWebToken.encode(user_id: user.id) }

    context "when there is no logged in user" do
      let!(:token) { nil }

      it { is_expected.to have_http_status(401) }

      it "returns an error" do
        expect(JSON.parse(result.body)).to eq({
          "errors" => "Unauthorized"
        })
      end
    end

    context "when trying to update another user's info" do
      let!(:another_user) { User.create(name: "user", handle: "handle", email: "email@gmail.com", password: "password") }
      let!(:token) { Api::JsonWebToken.encode(user_id: another_user.id) }

      it { is_expected.to have_http_status(401) }

      it "returns an error" do
        expect(JSON.parse(result.body)).to eq({
          "errors" => "Unauthorized"
        })
      end
    end

    context 'when the request is valid' do
      it { is_expected.to have_http_status(200) }

      it 'updates the user' do
        expect { result }.to change { user.reload.name }.from("Macarena").to("Macarena Peche")
      end

      # UPDATE: DONE. Here should be a test checking the response like `expect(JSON.parse(result.body)).to match(...)`
      it 'responds with correct data' do
        expect(JSON.parse(result.body)).to match(hash_including("name"=>"Macarena Peche")) 
      end
    end

    context 'when the request is invalid' do
      before { put "/api/users/#{user.id}", params: { user: {name: ""} } } # UPDATE: DONE. REVIEW: If we don't send a key, it is not empty, we should send smth like { name: "" } or { name: nil } 

      specify { expect(response).to have_http_status(422) }

      it 'returns a failure message' do
        expect(JSON.parse(response.body)).to match({
          "name"=>["can't be blank"],
        }) # UPDATE: DONE. REVIEW: check the body more precisely with JSON.parse and etc 
      end
    end

    context 'when user does not exist' do
      include_examples 'user does not exist'

      # REVIEW: a little different, but valid (if you rename the shared example): 
      # it_behaves_like 'non-existent user'
    end
  end

  describe 'DELETE /api/users/:id' do
    include_context 'when user exists'
    let!(:result) { delete "/api/users/#{user_id}", headers: headers; response }
    let!(:headers) { { "Authorization": token }}
    let!(:token) { Api::JsonWebToken.encode(user_id: user.id) } 

    specify { expect(result).to have_http_status(204) }

    context "when trying to delete another user" do
      let!(:another_user) { User.create(name: "user", handle: "handle", email: "email@gmail.com", password: "password") }
      let!(:token) { Api::JsonWebToken.encode(user_id: another_user.id) }

      specify { expect(result).to have_http_status(401) }

      it "returns an error" do 
        expect(JSON.parse(result.body)).to eq({
          "errors"=>"Unauthorized"
        })
      end
    end

    context 'when user does not exist' do
      include_examples 'user does not exist'
    end
  end

  describe 'GET /api/users/:id/followers' do
    subject(:result) do
      get "/api/users/#{user_id}/followers"
      response
    end

    context 'when user exists' do
      include_context 'when user exists'
      let!(:follower) { User.create(name: "follower", handle: "follower", email: "follower@toptal.com", password: "password") }
      let!(:follow) { Follow.create(user_id: user.id, follower_id: follower.id) }


      it { expect(result).to have_http_status(200) }

      it 'returns the followers' do
        expect(JSON.parse(result.body)).to include(
          hash_including("name"=>"follower", "handle"=>"follower", "email"=>"follower@toptal.com")
        )
      end
    end

    context 'when user does not exist' do
      include_examples 'user does not exist'
    end
  end

  describe 'GET /api/users/:id/followers' do
    subject(:result) do
      get "/api/users/#{user_id}/following"
      response
    end

    context 'when user exists' do
      include_context 'when user exists'
      let!(:following) { User.create(name: "following", handle: "following", email: "following@toptal.com", password: "password") }
      let!(:follow) { Follow.create(user_id: following.id, follower_id: user.id) }


      it { expect(result).to have_http_status(200) }

      it 'returns the followings' do
        expect(JSON.parse(result.body)).to include(
          hash_including("name"=>"following", "handle"=>"following", "email"=>"following@toptal.com")
        )
      end
    end

    context 'when user does not exist' do
      include_examples 'user does not exist'
    end
  end
end
