RSpec.describe "Comments API" do
  let!(:user) { User.create(name: "Macarena", handle: "mapeciris", email: "macarena@toptal.com") }
  let!(:another_user) { User.create(name: "name", handle: "handle", email: "email@domain.com") }

  describe 'GET /api/tweets/:tweet_id/comments' do
    subject(:result) do
      get "/api/tweets/#{tweet_id}/comments"
      response
    end

    context 'when tweet exists' do
      include_context 'when tweet exists'
      
      it { is_expected.to have_http_status(200) }

      specify { expect(JSON.parse(result.body)).to eq([]) }
  
      context "with comments" do 
        let!(:comment) { Comment.create(content: "cool tweet", tweet_id: tweet.id, user_id: another_user.id) }
  
        it 'responds with correct data' do
          expect(JSON.parse(result.body)).to match([hash_including("content" => "cool tweet", "tweet_id" => tweet.id, "user_id" => another_user.id)])
        end
      end
    end

    context 'when tweet does not exist' do
      include_examples 'tweet does not exist'
    end
  end

  describe "POST /api/tweets/:tweet_id/comments" do
    include_context 'when tweet exists'

    subject(:result) do
      post "/api/tweets/#{tweet_id}/comments", params: valid_params
      response
    end

    context 'when request is valid' do
      let(:valid_params) { { content: "cool tweet", tweet_id: tweet.id, user_id: another_user.id } }

      it { is_expected.to have_http_status(201) }

      it 'creates a like on the tweet' do
        expect { result }.to change { tweet.comments.count }.by(1)
      end

      it 'responds with correct data' do
        expect(JSON.parse(result.body)['id']).to eq(1)
        expect(JSON.parse(result.body)['content']).to eq("cool tweet")
        expect(JSON.parse(result.body)['tweet_id']).to eq(tweet.id)
        expect(JSON.parse(result.body)['user_id']).to eq(another_user.id)
      end
    end

    context 'when request is invalid' do
      before { post "/api/tweets/#{tweet_id}/comments", params: {} }
      
      it { expect(response).to have_http_status(422) }

      it 'returns a failure message' do
        expect(JSON.parse(response.body)).to match({
          "content"=>["can't be blank"],
          "user_id"=>["can't be blank"],
          "user"=>["must exist"],
        }) 
      end

      it 'does not create a comment' do
        expect { response }.not_to change(Comment, :count)
      end
    end
    
    context 'when tweet does not exist' do
      let(:valid_params) { { content: "cool tweet", tweet_id: tweet.id, user_id: another_user.id } }
      
      include_examples "tweet does not exist"
    end
  end

  describe 'PUT /api/tweets/:tweet_id/comments/:id' do
    include_context 'when tweet exists'
    let!(:comment) { Comment.create(content: "cool tweet", tweet_id: tweet.id, user_id: another_user.id) }
    let!(:comment_id) { comment.id } 
    subject(:result) do
      put "/api/tweets/#{tweet_id}/comments/#{comment_id}", params: { content: "cool tweet - edited" }
      response
    end

    context 'when the request is valid' do
      it { is_expected.to have_http_status(200) }

      it 'updates the comment' do
        expect { result }.to change { comment.reload.content }.from("cool tweet").to("cool tweet - edited")
      end

      it 'responds with correct data' do
        expect(JSON.parse(result.body)).to match(hash_including("content"=>"cool tweet - edited")) 
      end
    end

    context 'when the request is invalid' do
      before { put "/api/tweets/#{tweet_id}/comments/#{comment_id}", params: { content: "" }; response }

      specify { expect(response).to have_http_status(422) }

      it 'returns a failure message' do
        expect(JSON.parse(response.body)).to match({
          "content"=>["can't be blank"],
        }) 
      end
    end

    context 'when comment does not exist' do
      include_examples 'comment does not exist'
    end

    context 'when tweet does not exist' do
      include_examples 'tweet does not exist'
    end
  end

  describe 'DELETE /api/tweets/:tweet_id/comments/:id' do
    include_context 'when tweet exists'
    let!(:comment) { Comment.create(content: "cool tweet", tweet_id: tweet.id, user_id: another_user.id) }
    let!(:comment_id) { comment.id }
    let!(:result) { delete "/api/tweets/#{tweet_id}/comments/#{comment_id}"; response }

    context 'when tweet exists' do
      specify { expect(result).to have_http_status(204) }

      context 'when comment does not exist' do
        include_examples 'comment does not exist'
      end
    end

    context 'when tweet does not exist' do
      include_examples "tweet does not exist"
    end
  end
end
