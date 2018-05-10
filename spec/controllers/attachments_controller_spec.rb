require 'rails_helper'

RSpec.describe AttachmentsController, type: :controller do
  sign_in_user
  let(:question) { create(:question, user: @user) }
  let!(:file) { create(:attachment, attachable: question) }

  let(:user2) { create(:user) }
  let(:question2) { create(:question, user: user2) }
  let!(:file2) { create(:attachment, attachable: question2) }

  describe 'DELETE #destroy' do
    context 'delete self files' do
      it 'remove file' do
        expect { delete :destroy, params: { id: file }, format: :js }
               .to change(question.attachments, :count).by(-1)
      end

      it 'render destroy template' do
        delete :destroy, params: { id: file }, format: :js
        expect(response).to render_template :destroy
      end
    end

    context "delete non self files" do
      it "Delete answer's file" do
        expect { delete :destroy, params: { id: file2 }, format: :js }
               .to_not change(Attachment, :count)
      end

      it "redirect to attachable's view" do
        delete :destroy, params: { id: file2 }

        expect(response).to redirect_to question_path(question2)
      end
    end
  end
end
