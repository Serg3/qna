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
                           answer: attributes_for(:answer),
                           format: :js
                         }
               }.to change(question.answers, :count).by(1)
      end

      it 'render create template' do
        post :create, params: { question_id: question,
                                answer: attributes_for(:answer),
                                format: :js
                              }
        expect(response).to render_template :create
      end

      it "check answer's author with logged user" do
        expect { post :create,
                 params: { question_id: question,
                           answer: attributes_for(:answer),
                           format: :js
                         }
               }.to change(@user.answers, :count).by(1)
      end
    end

    context 'with invalid attributes' do
      it 'does not save the answer' do
        expect { post :create,
                 params: { question_id: question,
                           answer: attributes_for(:invalid_question),
                           format: :js
                         }
               }.to_not change(Answer, :count)
      end

      it 'render create template' do
        post :create, params: { question_id: question,
                                answer: attributes_for(:invalid_question),
                                format: :js
                              }
        expect(response).to render_template :create
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
