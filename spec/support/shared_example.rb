# REVIEW: this staff is conventionally put to `spec/support` folder, not to mess up with real tests
# You can build a whole structure there
# it might be that this folder is not loaded by default and you need to fix the spec_helper

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

RSpec.shared_examples 'comment does not exist' do
  let!(:comment_id) { 0 }

  it { expect(result).to have_http_status(404) }

  it 'returns a not found message' do 
    expect(JSON.parse(result.body)).to eq("error" => "Couldn't find Comment with 'id'=0")
  end
end
