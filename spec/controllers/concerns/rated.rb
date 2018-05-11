require 'rails_helper'

shared_examples_for 'rated' do
  sign_in_user
  let(:user2) { create(:user) }

  describe 'POST #like' do
    it 'user rates for self resource' do
      expect { post :like, params: { id: resource } }.to_not change(resource.ratings, :count)
    end

    it "user rates for non self resource" do
      expect { post :like, params: { id: resource2 } }.to change(resource2.ratings, :count).by(1)
    end

    it 'user rates twice' do
      post :like, params: { id: resource2 }

      expect(post :like, params: { id: resource2 }).to have_http_status(:unprocessable_entity)
    end
  end

  describe 'POST #dislike' do
    it 'user rates for self resource' do
      expect { post :dislike, params: { id: resource } }.to_not change(resource.ratings, :count)
    end

    it "user rates for non self resource" do
      expect { post :dislike, params: { id: resource2 } }.to change(resource2.ratings, :count).by(1)
    end

    it 'user rates twice' do
      post :dislike, params: { id: resource2 }

      expect(post :dislike, params: { id: resource2 }).to have_http_status(:unprocessable_entity)
    end
  end

  describe 'POST #cancel' do
    it "user cancels self vote" do
      post :like, params: { id: resource2 }

      expect { post :cancel, params: { id: resource2 } }.to change(resource2.ratings, :count).by(-1)
    end
  end
end
