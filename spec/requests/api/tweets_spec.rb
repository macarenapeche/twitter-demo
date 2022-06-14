RSpec.describe 'Tweets API', type: :request do
  let!(:user) { User.create(name: "Macarena", handle: "mapeciris", email: "macarena@toptal.com") }

  describe 'GET /api/tweets' do
    subject(:result) do
      get "/api/tweets"
      response
    end

    it { is_expected.to have_http_status(200)}
    specify { expect(JSON.parse(result.body)).to eq([]) }

    context 'with tweets' do
      let!(:tweet) { Tweet.create(content: "some content", user_id: user.id) }

      it 'shows tweet attributes' do
        expect(JSON.parse(result.body)).to match([hash_including("content" => "some content", "user_id" => user.id)])
      end
    end
  end

  describe 'POST /api/tweets' do
    subject(:result) do 
      post "/api/tweets", params: valid_params
      response
    end

    context 'when request is valid' do
      let(:valid_params) { { content: "some content", user_id: user.id } }

      it { is_expected.to have_http_status(201) }

      it 'creates a tweet' do
        expect { result }.to change { Tweet.all.count }.by(1)
      end
    end

    context 'when request is invalid' do
      before { post '/api/tweets', params: {} }
      
      it { expect(response).to have_http_status(422) }

      it 'returns a failure message' do
        expect(response.body).to include("can't be blank")
      end
    end
  end

  describe 'GET /api/tweets/:id' do
    subject(:result) do
      get "/api/tweets/#{tweet_id}"
      response
    end

    context 'when tweet exists' do
      let!(:tweet) { Tweet.create(content: 'some content', user_id: user.id) }
      let!(:tweet_id) { tweet.id }

      it { is_expected.to have_http_status(200) }

      it 'returns the tweet' do
        expect(JSON.parse(result.body)['id']).to eq(tweet_id)
      end
    end

    context 'when tweet does not exist' do
      let!(:tweet_id) { 0 }

      it { is_expected.to have_http_status(404) }

      it 'returns a not found message' do 
        expect(JSON.parse(result.body)).to include("Couldn't find Tweet with 'id'=0")
      end
    end
  end


  describe 'PUT /api/tweets/:id' do
    let!(:tweet) { Tweet.create(content: 'some content', user_id: user.id) }
    let!(:tweet_id) { tweet.id }

    subject(:result) do
      put "/api/tweets/#{tweet_id}", params: { content: "content - edited", user_id: user.id }
      response
    end

    context 'when the request is valid' do
      it { is_expected.to have_http_status(202) }

      it 'updates the tweet' do
        expect { result }.to change { tweet.content }
      end
    end

    context 'when the request is invalid' do
      before { put "/api/tweets/#{tweet_id}", params: {}; response }

      specify { expect(response).to have_http_status(422) }

      it 'returns a failure message' do
        expect(response.body).to include("can't be blank")
      end
    end
  end

  describe 'DELETE /api/tweets/:id' do
    let!(:tweet) { Tweet.create(content: 'some content', user_id: user.id) }
    let!(:tweet_id) { tweet.id }

    before { delete "/api/tweets/#{tweet_id}" }

    specify { expect(response).to have_http_status(204) }
  end
end
