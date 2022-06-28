RSpec.describe 'Likes API' do
  let!(:user) { User.create(name: "Macarena", handle: "mapeciris", email: "macarena@toptal.com") }
  let!(:another_user) { User.create(name: "name", handle: "handle", email: "email@domain.com") }
  let!(:tweet) { Tweet.create(content: "some content", user_id: user.id) }

  describe "GET /api/tweets/:tweet_id/likes" do
    subject(:result) do
      get "/api/tweets/#{tweet_id}/likes"
      response
    end

    context 'when tweet exists' do
      include_context 'when tweet exists'

      it { is_expected.to have_http_status(200) }

      specify { expect(JSON.parse(result.body)).to eq([]) }
  
      context "with likes" do 
        let!(:like) { Like.create(tweet_id: tweet.id, user_id: another_user.id) }
  
        it 'responds with correct data' do
          expect(JSON.parse(result.body)).to match([
            hash_including("tweet_id" => tweet.id, "user_id" => another_user.id)
          ])
        end
      end
    end

    context 'when tweet does not exist' do
      include_examples 'tweet does not exist'
    end
  end 

  describe "POST /api/tweets/:tweet_id/likes" do
    let!(:tweet_id) { tweet.id }

    subject(:result) do
      post "/api/tweets/#{tweet_id}/likes", params: valid_params
      response
    end

    context 'when request is valid' do
      let(:valid_params) { { tweet_id: tweet.id, user_id: another_user.id } }

      it { is_expected.to have_http_status(201) }

      it 'creates a like on the tweet' do
        expect { result }.to change { tweet.likes.count }.by(1)
      end

      it 'responds with correct data' do
        expect(JSON.parse(result.body)['id']).to eq(1)
        expect(JSON.parse(result.body)['tweet_id']).to eq(tweet.id)
        expect(JSON.parse(result.body)['user_id']).to eq(another_user.id)
      end
    end

    context 'when request is invalid' do
      before { post "/api/tweets/#{tweet_id}/likes", params: {} }
      
      it { expect(response).to have_http_status(422) }

      it 'returns a failure message' do
        expect(JSON.parse(response.body)).to match({
          "user_id"=>["can't be blank"],
          "user"=>["must exist"],
        }) 
      end

      it 'does not create a like' do
        expect { response }.not_to change(Like, :count)
      end
    end
    
    context 'when tweet does not exist' do
      let(:valid_params) { { tweet_id: tweet.id, user_id: another_user.id } }
      
      include_examples "tweet does not exist"
    end
  end

  describe 'DELETE /api/tweets/:tweet_id/likes/:id' do
    let!(:like) { Like.create(tweet_id: tweet.id, user_id: another_user.id) }
    let!(:result) { delete "/api/tweets/#{tweet_id}/likes/#{like.id}"; response }

    context 'when tweet exists' do
      let!(:tweet_id) { tweet.id }

      specify { expect(result).to have_http_status(204) }

      context 'when like does not exist' do
        let!(:like_id) { 0 }
        let!(:result) { delete "/api/tweets/#{tweet_id}/likes/#{like_id}"; response }

        it { expect(result).to have_http_status(404) }

        it 'returns a not found message' do 
          expect(JSON.parse(result.body)).to eq("error" => "Couldn't find Like with 'id'=0")
        end
      end
    end

    context 'when tweet does not exist' do
      include_examples "tweet does not exist"
    end
  end
end
