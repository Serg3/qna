shared_examples_for "API Authenticable" do

  context 'unauthorized' do
    it 'returns 401 status code if there is no access_token' do
      do_request
      expect(response.status).to eq 401
    end

    it 'returns 401 status code if access_token is invalid' do
      do_request(access_token: '1234')
      expect(response.status).to eq 401
    end
  end

end

shared_examples_for "response successful" do

  it 'returns 200 status' do
    expect(response).to be_successful
  end

end

shared_examples_for "return array size" do |resource, count, resource_path = ''|

  it "returns #{resource}" do
    expect(response.body).to have_json_size(count).at_path(resource_path)
  end
  
end
