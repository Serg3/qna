require 'rails_helper'

describe 'answers API' do

  let(:user) { create(:user) }

  let!(:questions) { create_list(:question, 3, user: user) }
  let(:question) { questions.first }
  
  let!(:answers) { create_list :answer, 3, question: question, user: user }

  describe 'GET #index' do

    context 'unauthorized' do
      it 'returns 401 status if there is no access_token' do
        get "/api/v1/questions/#{question.id}/answers", params: { format: :json }

        expect(response.status).to eq 401
      end

      it 'returns 401 status if access_token is invalid' do
        get "/api/v1/questions/#{question.id}/answers", params: { format: :json,
                                                                  access_token: '1234'
                                                                }

        expect(response.status).to eq 401
      end
    end

    context 'authorized' do
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

      %w(id body created_at updated_at).each do |attr|
        it "answer object contains #{attr}" do
          expect(response.body).to be_json_eql(question.send(attr.to_sym).to_json)
                                               .at_path("0/#{attr}"
                                               )
        end
      end
    end

  end

  describe 'GET #show' do

    let(:answer) { answers.first }

    context 'unauthorized' do
      it 'returns 401 status if there is no access_token' do
        get "/api/v1/answers/#{answer.id}", params: { format: :json }

        expect(response.status).to eq 401
      end

      it 'returns 401 status if access_token is invalid' do
        get "/api/v1/answers/#{answer.id}", params: { format: :json, access_token: '1234' }

        expect(response.status).to eq 401
      end
    end

    context 'authorized' do
      let(:user) { create(:user) }

      let!(:attachments) { create_list :attachment, 3, attachable: answer }
      let(:attachment) { attachments.last }

      let!(:comments) { create_list :comment, 3, commentable: answer, user: user }
      let(:comment) { comments.last }

      let(:access_token) { create(:access_token, resource_owner_id: user.id) }

      before { get "/api/v1/answers/#{answer.id}", params: { format: :json,
                                                            access_token: access_token.token
                                                            } }

      it 'returns 200 status' do
        expect(response).to be_successful
      end

      it 'returns attachments for question' do
        expect(response.body).to have_json_size(3).at_path('attachments')
      end

      it 'attachments object contains file' do
        expect(response.body).to be_json_eql(attachment.file.to_json).at_path('attachments/0/file')
      end

      it 'returns comments for question' do
        expect(response.body).to have_json_size(3).at_path('comments')
      end

      %w(id body created_at updated_at).each do |attr|
        it "comments object contains #{attr}" do
          expect(response.body).to be_json_eql(comment.send(attr.to_sym).to_json)
                                               .at_path("comments/0/#{attr}"
                                               )
        end
      end

      %w(id body created_at updated_at).each do |attr|
        it "answer object contains #{attr}" do
          expect(response.body).to be_json_eql(answer.send(attr.to_sym).to_json).at_path(attr)
        end
      end
    end

  end

  describe 'POST #create' do

    context 'unauthorized' do
      it 'returns 401 status if there is no access_token' do
        post "/api/v1/questions/#{question.id}/answers", params: { format: :json }

        expect(response.status).to eq 401
      end

      it 'returns 401 status if access_token is invalid' do
        post "/api/v1/questions/#{question.id}/answers", params: { format: :json,
                                                                   access_token: '1234'
                                                                 }

        expect(response.status).to eq 401
      end
    end

    context 'authorized' do
      let(:user) { create(:user) }
      let(:access_token) { create(:access_token, resource_owner_id: user.id) }

      context 'with valid attributes' do
        it 'saves the new answer in the database' do
          expect { answer_create(:answer, question) }.to change(Answer, :count).by(1)
        end

        it 'associates the answer with the question' do
          expect { answer_create(:answer, question) }.to change(question.answers, :count).by(1)
        end
      end

      context 'with invalid attributes' do
        it 'does not save the answer' do
          expect { answer_create(:invalid_answer, question) }.to_not change(Answer, :count)
        end
      end
    end

    def answer_create(attribute, question)
      post "/api/v1/questions/#{question.id}/answers",
           params: { question_id: question,
                     answer: attributes_for(attribute),
                     format: :json,
                     access_token: access_token.token
                   }
    end

  end

end
