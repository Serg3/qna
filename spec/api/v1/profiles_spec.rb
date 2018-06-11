require 'rails_helper'

describe 'Profile API' do

  describe 'GET #me' do
    it_behaves_like "API Authenticable"

    context 'authorized' do
      let(:me) { create(:user) }
      let(:access_token) { create(:access_token, resource_owner_id: me.id) }

      before do
        get '/api/v1/profiles/me',
        params: { format: :json, access_token: access_token.token }
      end

      it_behaves_like "response successful"

      %w(id email created_at updated_at).each do |attr|
        it "contains #{attr}" do
          expect(response.body).to be_json_eql(me.send(attr.to_sym).to_json).at_path(attr)
        end
      end

      %w(password encrypted_password).each do |attr|
        it "does not contain #{attr}" do
          expect(response.body).to_not have_json_path(attr)
        end
      end
    end

    def do_request(options = {})
      get '/api/v1/profiles/me', params: { format: :json }.merge(options)
    end
  end

  describe 'GET #index' do
    it_behaves_like "API Authenticable"

    context 'authorized' do
      let(:me) { create(:user) }
      let!(:users) { create_list(:user, 3) }
      let(:access_token) { create(:access_token, resource_owner_id: me.id) }

      before do
        get '/api/v1/profiles/',
        params: { format: :json, access_token: access_token.token }
      end

      it_behaves_like "response successful"

      it_behaves_like "return array size", 'users', 3

      it 'contains users' do
        expect(response.body).to be_json_eql(users.to_json)
      end

      it 'does not have me-profile' do
        expect(response.body).to_not include_json(me.to_json)
      end
    end

    def do_request(options = {})
      get '/api/v1/profiles/', params: { format: :json }.merge(options)
    end
  end

end
