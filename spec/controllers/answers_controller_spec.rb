require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  sign_in_user
  let!(:question) { create(:question, user: @user) }
  let(:answer) { create(:answer, question: question, user: @user) }
  let!(:user2) { create(:user) }
  let!(:answer2) { create(:answer, question: question, user: user2) }

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

  describe 'PUT #update' do
    it 'assigns the requested answer to @answer' do
      put :update, params: { id: answer,
                             question_id: question,
                             answer: attributes_for(:answer),
                             format: :js
                           }

      expect(assigns(:answer)).to eq answer
    end

    it 'changes answer attributes' do
      put :update, params: { id: answer,
                             question_id: question,
                             answer: { body: 'edited answer' },
                             format: :js
                           }
      answer.reload

      expect(answer.body).to eq 'edited answer'
    end

    it 'render update template' do
      put :update, params: { id: answer,
                             question_id: question,
                             answer: attributes_for(:answer),
                             format: :js
                           }

      expect(response).to render_template :update
    end
  end

  describe 'PUT #set_best' do
    let(:question2) { create(:question, user: user2) }
    let(:answer3) { create(:answer, question: question2, user: user2) }

    it 'assigns the requested answer to @answer' do
      put :set_best, params: { id: answer }, format: :js

      expect(assigns(:answer)).to eq answer
    end

    it 'an author set the best answer' do
      put :set_best, params: { id: answer }, format: :js
      answer.reload

      expect(answer).to be_best
    end

    it 'a non author of question tries to set the best answer' do
      put :set_best, params: { id: answer3 }, format: :js

      expect(flash[:alert]).to eq "You are not authorized to access this page."
    end
  end

  describe 'DELETE #destroy' do
    context 'delete self answer' do
      it 'delete answer' do
        answer

        expect { delete :destroy,
                 params: { id: answer },
                 format: :js
               }.to change(Answer, :count).by(-1)
      end

      it 'render destroy template' do
        delete :destroy, params: { id: answer }, format: :js

        expect(response).to render_template :destroy
      end
    end

    context 'delete non self answer' do
      it 'delete answer' do
        expect { delete :destroy, params: { id: answer2 } }.to_not change(Answer, :count)
      end
    end
  end

  it_behaves_like 'rated' do
    let(:resource) { create(:answer, user: @user, question: question) }
    let(:resource2) { create(:answer, user: user2, question: question) }
  end
end
