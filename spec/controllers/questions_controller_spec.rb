require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
  sign_in_user
  let(:question) { create(:question, user: @user) }

  describe 'GET #index' do
    let(:questions) { create_list(:question, 2, user: @user) }

    before { get :index }

    it 'populates an array of all questions' do
      expect(assigns(:questions)).to match_array(questions)
    end

    it 'renders index view' do
      expect(response).to render_template :index
    end
  end

  describe 'GET #show' do
    before { get :show, params: { id: question } }

    it 'assigns the requested question to @question' do
      expect(assigns(:question)).to eq question
    end

    it 'builds new attachment for answer' do
      expect(assigns(:answer).attachments.first).to be_a_new(Attachment)
    end

    it 'renders show view' do
      expect(response).to render_template :show
    end
  end

  describe 'GET #new' do
    before { get :new }

    it 'assigns a new Question to @question' do
      expect(assigns(:question)).to be_a_new(Question)
    end

    it 'builds new attachment for question' do
      expect(assigns(:question).attachments.first).to be_a_new(Attachment)
    end

    it 'renders new view' do
      expect(response).to render_template :new
    end
  end

  describe 'POST #create' do
    context 'with valid attributes' do
      it 'saves the new question' do
        expect { post :create,
                 params: { question: attributes_for(:question) }
               }.to change(Question, :count).by(1)
      end

      it 'redirects to show view' do
        post :create, params: { question: attributes_for(:question) }
        expect(response).to redirect_to question_path(assigns(:question))
      end

      it "check question's author with logged user" do
        expect { post :create,
                 params: { question: attributes_for(:question) }
               }.to change(@user.questions, :count).by(1)
      end
    end

    context 'with invalid attributes' do
      it 'does not save the question' do
        expect { post :create,
                 params: { question: attributes_for(:invalid_question) }
               }.to_not change(Question, :count)
      end

      it 're-renders new view' do
        post :create, params: { question: attributes_for(:invalid_question) }
        expect(response).to render_template :new
      end
    end
  end

  describe 'PUT #update' do
    it 'assigns the requested question to @question' do
      put :update, params: { id: question, question: attributes_for(:question), format: :js }

      expect(assigns(:question)).to eq question
    end

    it 'changes question attributes' do
      put :update, params: { id: question,
                             question: { title: 'edited question title',
                                         body: 'edited question body'
                                         },
                             format: :js
                           }
      question.reload

      expect(question.title).to eq 'edited question title'
      expect(question.body).to eq 'edited question body'
    end

    it 'render update template' do
      put :update, params: { id: question, question: attributes_for(:question), format: :js }

      expect(response).to render_template :update
    end
  end

  describe 'DELETE #destroy' do
    context 'delete self question' do
      it 'delete question' do
        question

        expect { delete :destroy, params: { id: question } }.to change(Question, :count).by(-1)
      end

      it 'redirect to index view' do
        delete :destroy, params: { id: question }

        expect(response).to redirect_to questions_path
      end
    end

    context 'delete non self question' do
      before do
        @user2 = create(:user)
        @question2 = create(:question, user: @user2)
      end

      it 'delete question' do
        expect { delete :destroy, params: { id: @question2 } }.to_not change(Question, :count)
      end

      it 'redirect to index view' do
        delete :destroy, params: { id: @question2 }

        expect(response).to redirect_to questions_path
      end
    end
  end

  it_behaves_like 'rated' do
    let(:resource) { create(:question, user: @user) }
    let(:resource2) { create(:question, user: user2) }
  end
end
