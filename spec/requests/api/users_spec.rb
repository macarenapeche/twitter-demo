RSpec.describe 'Users API', type: :request do
  describe 'GET /api/users' do
    subject(:result) do
      get '/api/users'
      response
    end

    it 'returns status code 200' do
      expect(result).to have_http_status(200)
    end

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

    let(:valid_params) { { name: "Macarena", handle: "mapeciris", email: "macarena@toptal.com" } }
    context 'when the request is valid' do
      it 'returns status code 201' do
        expect(result).to have_http_status(201)
      end

      it 'creates an user' do
        expect { result }.to change { User.all.length }.by(1)
      end
    end

    context 'when the request is invalid' do
      before { post '/api/users', params: {}; response }

      it 'returns status code 422' do
        expect(response).to have_http_status(422)
      end

      it 'returns a failure message' do
        expect(response.body).to include("can't be blank")
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
      let!(:user_id) { User.all.first.id }
      
      it 'returns status code 200' do
        expect(result).to have_http_status(200)
      end

      it 'returns the user' do
        expect(JSON.parse(result.body)['id']).to eq(user_id)
      end
    end

    context 'when user does not exist' do
      let(:user_id) { 0 }

      it 'returns a status code 404' do
        expect(result).to have_http_status(404)
      end

      it 'returns a not found message' do
        expect(JSON.parse(result.body)).to include("Couldn't find User with 'id'=0")
      end
    end
  end

  describe 'PUT /api/users/:id' do
    let!(:user) { User.create(name: "Macarena", handle: "mapeciris", email: "macarena@toptal.com") }
    let!(:user_id) { User.all.first.id }
    
    subject(:result) do
      put "/api/users/#{user_id}", params: { name: "Macarena Peche", handle: "mapeciris", email: "macarena@toptal.com" }
      response
    end

    context 'when the request is valid' do
      it 'returns status code 202' do
        expect(result).to have_http_status(202)
      end

      it 'updates the user' do
        expect { result }.to change { user.name }
      end
    end

    context 'when the request is invalid' do
      before { put "/api/users/#{user_id}", params: {}; response }

      it 'returns status code 422' do
        expect(response).to have_http_status(422)
      end

      it 'returns a failure message' do
        expect(response.body).to include("can't be blank")
      end
    end
  end

  describe 'DELETE /api/users/:id' do
    let!(:user) { User.create(name: "Macarena", handle: "mapeciris", email: "macarena@toptal.com") }
    let!(:user_id) { User.all.first.id }

    before { delete "/api/users/#{user_id}" }
    it 'returns status code 204' do
      expect(response).to have_http_status(204)
    end
  end
end
