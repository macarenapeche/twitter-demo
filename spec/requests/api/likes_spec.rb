RSpec.describe 'Likes API' do
  let!(:user) { User.create(name: "Macarena", handle: "mapeciris", email: "macarena@toptal.com") }
  let!(:another_user) { User.create(name: "name", handle: "handle", email: "email@domain.com") }
  let!(:tweet) { Tweet.create(content: "some content", user_id: user.id) }

  describe "GET /api/tweets/:tweet_id/likes" do
    subject(:result) do
      get "/api/tweets/#{tweet.id}/likes"
      response
    end

    it { is_expected.to have_http_status(200) }
    specify { expect(JSON.parse(result.body)).to eq([]) }


    context "with likes" do 
      let!(:like) { Like.create(tweet_id: tweet.id, user_id: another_user.id) }

      it 'shows the like' do
        expect(JSON.parse(result.body)).to match([hash_including("tweet_id" => tweet.id, "user_id" => another_user.id)])
      end
    end
  end 

  describe "POST /api/tweets/:tweet_id/likes" do
    subject(:result) do
      post "/api/tweets/#{tweet.id}/likes", params: valid_params
      response
    end

    context 'when request is valid' do
      let(:valid_params) { { tweet_id: tweet.id, user_id: another_user.id } }

      it { is_expected.to have_http_status(201) }

      it 'creates a like on the tweet' do
        expect { result }.to change { tweet.likes.count }.by(1)
      end
    end

    context 'when request is invalid' do
      before { post "/api/tweets/#{tweet.id}/likes", params: {} }
      
      it { expect(response).to have_http_status(422) }

      it 'returns a failure message' do
        expect(JSON.parse(response.body)).to match({
          "user_id"=>["can't be blank"],
          "user"=>["must exist"],
        }) 
      end
    end    
  end

  describe 'DELETE /api/tweets/:tweet_id/likes/:id' do
    let!(:like) { Like.create(tweet_id: tweet.id, user_id: another_user.id) }

    before { delete "/api/tweets/#{tweet.id}/likes/#{like.id}" }

    specify { expect(response).to have_http_status(204) }
  end
end
