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

      it 'returns status code 201' do
        expect(result).to have_http_status(201)
      end

      it 'creates an user' do
        expect { result }.to change { User.all.count }.by(1)
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
      it { is_expected.to have_http_status(202) }

      it 'updates the user' do
        expect { result }.to change { user.name }
      end
    end

    context 'when the request is invalid' do
      before { put "/api/users/#{user_id}", params: {}; response }

      specify { expect(response).to have_http_status(422) }

      it 'returns a failure message' do
        expect(response.body).to include("can't be blank")
      end
    end
  end

  describe 'DELETE /api/users/:id' do
    let!(:user) { User.create(name: "Macarena", handle: "mapeciris", email: "macarena@toptal.com") }
    let!(:user_id) { User.all.first.id }

    before { delete "/api/users/#{user_id}" }

    specify { expect(response).to have_http_status(204) }
  end
end
