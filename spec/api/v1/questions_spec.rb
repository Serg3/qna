require 'rails_helper'

describe 'questions API' do

  describe 'GET #index' do

    context 'unauthorized' do
      it 'returns 401 status if there is no access_token' do
        get '/api/v1/questions/', params: { format: :json }

        expect(response.status).to eq 401
      end

      it 'returns 401 status if access_token is invalid' do
        get '/api/v1/questions/', params: { format: :json, access_token: '1234' }

        expect(response.status).to eq 401
      end
    end

    context 'authorized' do
      let(:user) { create(:user) }
      let!(:questions) { create_list(:question, 3, user: user) }
      let(:question) { questions.first }
      let(:access_token) { create(:access_token, resource_owner_id: user.id) }

      before { get '/api/v1/questions/', params: { format: :json,
                                                   access_token: access_token.token
                                                   } }

      it 'returns 200 status' do
        expect(response).to be_successful
      end

      it 'returns list of questions' do
        expect(response.body).to have_json_size(3)
      end

      %w(id title body created_at updated_at).each do |attr|
        it "question object contains #{attr}" do
          expect(response.body).to be_json_eql(question.send(attr.to_sym).to_json)
                                               .at_path("0/#{attr}"
                                               )
        end
      end
    end

  end

  describe 'GET #show' do

    context 'unauthorized' do
      let(:user) { create(:user) }
      let(:question) { create :question, user: user }

      it 'returns 401 status if there is no access_token' do
        get "/api/v1/questions/#{question.id}", params: { format: :json }

        expect(response.status).to eq 401
      end

      it 'returns 401 status if access_token is invalid' do
        get "/api/v1/questions/#{question.id}", params: { format: :json, access_token: '1234' }

        expect(response.status).to eq 401
      end
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

      before { get "/api/v1/questions/#{question.id}", params: { format: :json,
                                                                 access_token: access_token.token
                                                                 } }

      it 'returns 200 status' do
        expect(response).to be_successful
      end

      it 'returns comments for question' do
        expect(response.body).to have_json_size(3).at_path('comments')
      end

      it 'returns attachments for question' do
        expect(response.body).to have_json_size(3).at_path('attachments')
      end

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

  end

  describe 'POST #create' do

    context 'unauthorized' do
      it 'returns 401 status if there is no access_token' do
        post "/api/v1/questions", params: { format: :json }

        expect(response.status).to eq 401
      end

      it 'returns 401 status if access_token is invalid' do
        post "/api/v1/questions", params: { format: :json, access_token: '1234' }

        expect(response.status).to eq 401
      end
    end

    context 'authorized' do
      let(:user) { create(:user) }
      let(:access_token) { create(:access_token, resource_owner_id: user.id) }

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

  end

end
