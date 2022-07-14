RSpec.describe 'Tweets API', type: :request do
  include_context "when user exists" 
  let!(:token) { Api::JsonWebToken.encode(user_id: user.id) }
  
  describe 'GET /api/tweets' do
    subject(:result) do
      get "/api/tweets"
      response
    end

    it { is_expected.to have_http_status(200)}

    specify { expect(JSON.parse(result.body)).to eq([]) }

    context 'with tweets' do
      include_context 'when tweet exists' 

      it 'shows tweet attributes' do
        expect(JSON.parse(result.body)).to match([hash_including(
          "content" => "some content", 
          "user_id" => user.id
        )])
      end
    end
  end

  describe 'POST /api/tweets' do
    subject(:result) do 
      post "/api/tweets", params: valid_params, headers: { "Authorization": token }
      response
    end

    context "when there is no logged in user" do
      include_examples "no logged in user"
      let(:valid_params) { { content: "some content", user_id: user.id } }
    end


    context 'when request is valid' do
      let(:valid_params) { { content: "some content", user_id: user.id } }

      it { is_expected.to have_http_status(201) }

      it 'creates a tweet' do
        expect { result }.to change(Tweet, :count).by(1)
      end

      it 'responds with correct data' do
        expect(JSON.parse(result.body)['id']).to eq(1)
        expect(JSON.parse(result.body)['content']).to eq("some content")
        expect(JSON.parse(result.body)['user_id']).to eq(user.id)
      end
    end

    context 'when request is invalid' do
      before { post '/api/tweets', params: {content: ""}, headers: { "Authorization": token } }
      
      it { expect(response).to have_http_status(422) }

      it 'returns a failure message' do
        expect(JSON.parse(response.body)).to match({
          "content"=>["can't be blank"]
        }) 
      end

      it 'does not create a tweet' do
        expect { response }.not_to change(Tweet, :count)
      end
    end
  end

  describe 'GET /api/tweets/:id' do
    subject(:result) do
      get "/api/tweets/#{tweet_id}"
      response
    end

    context 'when tweet exists' do
      include_context 'when tweet exists'

      it { is_expected.to have_http_status(200) }

      it 'responds with correct data' do
        expect(JSON.parse(result.body)['id']).to eq(1)
        expect(JSON.parse(result.body)['content']).to eq("some content")
        expect(JSON.parse(result.body)['user_id']).to eq(user.id)
      end
    end

    context 'when tweet does not exist' do
      include_examples 'tweet does not exist'
    end
  end


  describe 'PUT /api/tweets/:id' do
    include_context 'when tweet exists'

    subject(:result) do
      put "/api/tweets/#{tweet_id}", params: { content: "content - edited"},
                                     headers: { "Authorization": token }
      response
    end

    context "when there is no logged in user" do
      include_examples "no logged in user"
    end


    context "when another user sends the request" do
      let!(:another_user) { User.create(name: "name",handle: "handle", email: "email@gmail.com", password: "password")}
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

      it 'updates the tweet' do
        expect { result }.to change { tweet.reload.content }.from("some content").to("content - edited")
      end

      it 'responds with correct data' do
        expect(JSON.parse(result.body)).to match(hash_including("content"=>"content - edited")) 
      end
    end

    context 'when the request is invalid' do
      before do 
        put "/api/tweets/#{tweet_id}", params: { content: "" }, 
                                       headers: { "Authorization": token } 
        response 
      end

      specify { expect(response).to have_http_status(422) }

      it 'returns a failure message' do
        expect(JSON.parse(response.body)).to match({
          "content"=>["can't be blank"],
        }) 
      end
    end

    context 'when tweet does not exist' do
      include_examples 'tweet does not exist'
    end
  end

  describe 'DELETE /api/tweets/:id' do
    include_context 'when tweet exists'
    let!(:result) { delete "/api/tweets/#{tweet_id}", headers: { "Authorization": token }; response }

    specify { expect(result).to have_http_status(204) }

    context 'when tweet does not exist' do
      include_examples 'tweet does not exist'
    end

    context "when there is no logged in user" do
      include_examples "no logged in user"
    end

    context "when another user sends the request" do
      let!(:another_user) { User.create(name: "name",handle: "handle", email: "email@gmail.com", password: "password")}
      let!(:token) { Api::JsonWebToken.encode(user_id: another_user.id) }

      it { expect(result).to have_http_status(401) }

      it "returns an error" do
        expect(JSON.parse(result.body)).to eq({
          "errors" => "Unauthorized"
        })
      end
    end
  end
end
