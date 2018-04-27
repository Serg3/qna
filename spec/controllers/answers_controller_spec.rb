require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  sign_in_user
  let(:question) { create(:question, user: @user) }
  let(:answer) { create(:answer, question: question, user: @user) }
  let(:user2) { create(:user) }
  let!(:answer2) { create(:answer, user: user2, question: question) }

  describe 'POST #create' do
    context 'with valid attributes' do
      it 'saves the new answer' do
        expect { post :create,
                 params: { question_id: question,
                           answer: attributes_for(:answer) }
               }.to change(question.answers, :count).by(1)
      end

      it 'redirects to question view' do
        post :create, params: { question_id: question,
                                answer: attributes_for(:answer) }
        expect(response).to redirect_to question_path(question)
      end

      it "check answer's author with logged user" do
        expect { post :create,
                 params: { question_id: question,
                           answer: attributes_for(:answer) }
               }.to change(@user.answers, :count).by(1)
      end
    end

    context 'with invalid attributes' do
      it 'does not save the answer' do
        expect { post :create,
                 params: { question_id: question,
                           answer: attributes_for(:invalid_question) }
               }.to_not change(Answer, :count)
      end

      it 're-renders new view' do
        post :create, params: { question_id: question,
                                answer: attributes_for(:invalid_question) }
        expect(response).to render_template 'questions/show'
      end
    end
  end

  describe 'DELETE #destroy' do
    context 'delete self answer' do
      it 'delete answer' do
        answer

        expect { delete :destroy, params: { id: answer } }.to change(Answer, :count).by(-1)
      end

      it 'redirect to index view' do
        delete :destroy, params: { id: answer }

        expect(response).to redirect_to question_path(answer.question)
      end

      it "check answer's author with logged user" do
        answer
        
        expect { delete :destroy, params: { id: answer } }.to change(@user.answers, :count).by(-1)
      end
    end

    context 'delete non self answer' do
      it 'delete answer' do
        expect { delete :destroy, params: { id: answer2 } }.to_not change(Answer, :count)
      end

      it 'redirect to index view' do
        delete :destroy, params: { id: answer2 }

        expect(response).to redirect_to question_path(answer2.question)
      end
    end
  end
end
