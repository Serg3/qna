require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:question) { create(:question, user: @user) }
  let(:answer) { create(:answer, question: question, user: @user) }

  describe 'POST #create' do
    sign_in_user

    context 'with valid attributes' do
      it 'saves the new answer' do
        expect { post :create,
                 params: { question_id: question,
                           user: @user,
                           answer: attributes_for(:answer) }
               }.to change(question.answers, :count).by(1)
      end

      it 'redirects to question view' do
        post :create, params: { question_id: question,
                                user: @user,
                                answer: attributes_for(:answer) }
        expect(response).to redirect_to question_path(question)
      end
    end

    context 'with invalid attributes' do
      it 'does not save the answer' do
        expect { post :create,
                 params: { question_id: question,
                           user: @user,
                           answer: attributes_for(:invalid_question) }
               }.to_not change(Answer, :count)
      end

      it 're-renders new view' do
        post :create, params: { question_id: question,
                                user: @user,
                                answer: attributes_for(:invalid_question) }
        expect(response).to render_template 'questions/show'
      end
    end
  end
end
