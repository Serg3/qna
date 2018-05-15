require 'rails_helper'

RSpec.describe CommentsController, type: :controller do
  sign_in_user
  let!(:resource) { create(:question, user: @user) }

  describe 'POST #create' do
    context 'with valid attributes' do
      it 'stores comment in DB' do
        expect { post :create,
                 params: { question_id: resource, comment: attributes_for(:comment) },
                 format: :js
               }.to change(resource.comments, :count).by(1)
      end

      it 'associates comment with the user' do
        expect { post :create,
                 params: { question_id: resource, comment: attributes_for(:comment) },
                 format: :js
               }.to change(@user.comments, :count).by(1)
      end

      it 'renders create teamplate' do
        post :create, params: { question_id: resource,
                                comment: attributes_for(:comment)
                                }, format: :js

        expect(response).to render_template :create
      end
    end

    context 'with invalid parameters' do
      it 'comment does not save' do
        expect { post :create,
                 params: { question_id: resource, comment: attributes_for(:invalid_comment) },
                 format: :js
               }.to_not change(Comment, :count)
      end

      it 'renders create teamplate' do
        post :create, params: { question_id: resource,
                                comment: attributes_for(:invalid_comment)
                                }, format: :js

        expect(response).to render_template :create
      end
    end
  end
end
