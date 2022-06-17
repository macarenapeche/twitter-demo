
RSpec.shared_examples 'user does not exist' do
  let(:user_id) { 0 }

  specify { expect(result).to have_http_status(404) }

  it 'returns a not found message' do
    expect(JSON.parse(result.body)).to eq("error" => "Couldn't find User with 'id'=0")
  end
end

RSpec.shared_examples 'tweet does not exist' do
  let!(:tweet_id) { 0 }

  it { expect(result).to have_http_status(404) }

  it 'returns a not found message' do 
    expect(JSON.parse(result.body)).to eq("error" => "Couldn't find Tweet with 'id'=0")
  end
end
