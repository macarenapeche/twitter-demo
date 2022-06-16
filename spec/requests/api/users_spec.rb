RSpec.describe 'Users API', type: :request do
  describe 'GET /api/users' do
    subject(:result) do
      get '/api/users'
      response
    end

    it { is_expected.to have_http_status(200) }
    specify { expect(JSON.parse(result.body)).to eq([]) }

    context 'when has users' do
      let!(:user) { User.create(name: "Macarena", handle: "mapeciris", email: "macarena@toptal.com") }
      let(:json) { JSON.parse(result.body) }

      it { expect(json).not_to be_empty }
      
      it { expect(json).to match([hash_including("name" => "Macarena", "handle" => "mapeciris", "email" => "macarena@toptal.com")]) }
    end
  end

  describe  'POST /api/users' do
    subject(:result) do
      post '/api/users', params: valid_params
      response
    end

    context 'when the request is valid' do
      let(:valid_params) { { name: "Macarena", handle: "mapeciris", email: "macarena@toptal.com" } }

      it { is_expected.to have_http_status(201) }

      it 'creates an user' do
        expect { result }.to change(User, :count).by(1)
      end
    end

    context 'when the request is invalid' do
      before { post '/api/users', params: {} }

      specify { expect(response).to have_http_status(422) }

      it 'returns a failure message' do
        expect(JSON.parse(response.body)).to match({
          "name"=>["can't be blank", "is too short (minimum is 2 characters)"],
          "handle"=>["can't be blank", "is invalid"],
          "email"=>["can't be blank", "is invalid"]
        }) 
      end
    end
  end

  describe 'GET /api/users/:id' do
    subject(:result) do
      get "/api/users/#{user_id}"
      response
    end

    context 'when user exists' do
      let!(:user) { User.create(name: "Macarena", handle: "mapeciris", email: "macarena@toptal.com") }
      let!(:user_id) { user.id }

      it { is_expected.to have_http_status(200) }

      it 'returns the user' do
        expect(JSON.parse(result.body)['id']).to eq(user_id)
      end
    end

    context 'when user does not exist' do
      let(:user_id) { 0 }

      it { is_expected.to have_http_status(404) }

      it 'returns a not found message' do
        expect(JSON.parse(result.body)).to eq("error" => "Couldn't find User with 'id'=0")
      end
    end
  end

  describe 'PUT /api/users/:id' do
    let!(:user) { User.create(name: "Macarena", handle: "mapeciris", email: "macarena@toptal.com") }
    
    subject(:result) do
      put "/api/users/#{user.id}", params: { name: "Macarena Peche" }
      response
    end

    context 'when the request is valid' do
      it { is_expected.to have_http_status(200) }

      it 'updates the user' do
        expect { result }.to change { user.reload.name }.from("Macarena").to("Macarena Peche")
      end

      # Here should be a test checking the response like `expect(JSON.parse(result.body)).to match(...)`
      it 'updates the response' do
        expect(JSON.parse(result.body)).to match(hash_including("name"=>"Macarena Peche")) 
      end
    end

    context 'when the request is invalid' do
      before { put "/api/users/#{user.id}", params: { name: "" } } # UPDATE: DONE. REVIEW: If we don't send a key, it is not empty, we should send smth like { name: "" } or { name: nil } 

      specify { expect(response).to have_http_status(422) }

      it 'returns a failure message' do
        expect(JSON.parse(response.body)).to match({
          "name"=>["can't be blank", "is too short (minimum is 2 characters)"],
        }) # UPDATE: DONE. REVIEW: check the body more precisely with JSON.parse and etc 
      end
    end
  end

  describe 'DELETE /api/users/:id' do
    let!(:user) { User.create(name: "Macarena", handle: "mapeciris", email: "macarena@toptal.com") }
    let!(:user_id) { User.all.first.id }

    before { delete "/api/users/#{user_id}" }

    specify { expect(response).to have_http_status(204) }
  end

  # describe 'GET /api/users/:id/followers' do
  #   subject(:result) do
  #     get "/api/users/#{user_id}/followers"
  #     response
  #   end

  #   context 'when user exists' do
  #     let!(:user) { User.create(name: "Macarena", handle: "mapeciris", email: "macarena@toptal.com") }
  #     let!(:follower) { User.create(name: "follower", handle: "follower", email: "follower@toptal.com") }
  #     let!(:follow) { Follow.create(user_id: user.id, follower_id: follower.id) }
  #     let!(:user_id) { user.id }

  #     it { expect(result).to have_http_status(200) }

  #     it 'returns the followers' do
  #       expect(JSON.parse(result.body)).to match(hash_including("name" => "follower", "handle" => "follower", "email" => "follower"))
  #     end
  #   end

  #   context 'when user does not exist' do
  #     let(:user_id) { 0 }

  #     it { expect(result).to have_http_status(404) }

  #     it 'returns a not found message' do
  #       expect(JSON.parse(result.body)).to eq("error" => "Couldn't find User with 'id'=0")
  #     end
  #   end
  # end
end
