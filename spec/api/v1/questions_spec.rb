require 'rails_helper'

describe 'questions API' do

  describe 'GET #index' do
    it_behaves_like "API Authenticable"

    context 'authorized' do
      let(:user) { create(:user) }
      let!(:questions) { create_list(:question, 3, user: user) }
      let(:question) { questions.first }
      let(:access_token) { create(:access_token, resource_owner_id: user.id) }

      before do
        get '/api/v1/questions/',
        params: { format: :json, access_token: access_token.token }
      end

      it_behaves_like "response successful"

      it_behaves_like "return array size", 'questions', 3

      %w(id title body created_at updated_at).each do |attr|
        it "question object contains #{attr}" do
          expect(response.body).to be_json_eql(question.send(attr.to_sym).to_json)
                                               .at_path("0/#{attr}"
                                               )
        end
      end
    end

    def do_request(options = {})
      get '/api/v1/questions/', params: { format: :json }.merge(options)
    end
  end

  describe 'GET #show' do
    context 'unauthorized' do
      let(:user) { create(:user) }
      let(:question) { create :question, user: user }

      it_behaves_like "API Authenticable"
    end

    context 'authorized' do
      let(:user) { create(:user) }

      let!(:questions) { create_list(:question, 3, user: user) }
      let(:question) { questions.last }

      let!(:comments) { create_list :comment, 3, commentable: question, user: user }
      let(:comment) { comments.last }

      let!(:attachments) { create_list :attachment, 3, attachable: question }
      let(:attachment) { attachments.last }

      let(:access_token) { create(:access_token, resource_owner_id: user.id) }

      before do
        get "/api/v1/questions/#{question.id}",
        params: { format: :json, access_token: access_token.token }
      end

      it_behaves_like "response successful"

      it_behaves_like "return array size", 'comments', 3, 'comments'

      it_behaves_like "return array size", 'attachments', 3, 'attachments'

      it "attachments object contains file" do
        expect(response.body).to be_json_eql(attachment.file.to_json).at_path('attachments/0/file')
      end

      %w(id body created_at updated_at).each do |attr|
        it "comments object contains #{attr}" do
          expect(response.body).to be_json_eql(comment.send(attr.to_sym).to_json)
                                               .at_path("comments/0/#{attr}"
                                               )
        end
      end

      %w(id title body created_at updated_at).each do |attr|
        it "question object contains #{attr}" do
          expect(response.body).to be_json_eql(question.send(attr.to_sym).to_json).at_path(attr)
        end
      end
    end

    def do_request(options = {})
      get "/api/v1/questions/#{question.id}", params: { format: :json }.merge(options)
    end
  end

  describe 'POST #create' do
    it_behaves_like "API Authenticable"

    context 'authorized' do
      let(:user) { create(:user) }
      let(:access_token) { create(:access_token, resource_owner_id: user.id) }

      it 'returns 200 status' do
        question_create(:question)

        expect(response).to be_successful
      end

      context 'with valid attributes' do
        it 'saves the new question in the database' do
          expect { question_create(:question) }.to change(Question, :count).by(1)
        end

        it 'question is associated with the user' do
          expect { question_create(:question) }.to change(user.questions, :count).by(1)
        end
      end

      context 'with invalid attributes' do
        it 'does not save the question' do
          expect { question_create(:invalid_question) }.to_not change(Question, :count)
        end
      end
    end

    def question_create(attribute)
      post "/api/v1/questions", params: { question: attributes_for(attribute),
                                          format: :json,
                                          access_token: access_token.token
                                        }
    end

    def do_request(options = {})
      post "/api/v1/questions/", params: { format: :json }.merge(options)
    end
  end

end
